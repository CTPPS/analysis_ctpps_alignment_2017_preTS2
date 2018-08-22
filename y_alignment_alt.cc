#include "config.h"
#include "stat.h"
#include "alignment_classes.h"

#include "TFile.h"
#include "TH1D.h"
#include "TGraph.h"
#include "TCanvas.h"
#include "TF1.h"
#include "TProfile.h"

#include <vector>
#include <string>

using namespace std;

//----------------------------------------------------------------------------------------------------

int main()
{
	// load config
	if (cfg.LoadFrom("config.py") != 0)
	{
		printf("ERROR: cannot load config.\n");
		return 1;
	}

	printf("-------------------- config ----------------------\n");
	cfg.Print(false);
	printf("--------------------------------------------------\n");

	// list of RPs and their settings
	struct ArmData
	{
		string name;
		unsigned int rp_id_N;
		unsigned int rp_id_F;
		double corr_N;
		double corr_F;
	};

	vector<ArmData> armData = {
		{ "sector 45", 2, 3, +0.175, +0.175 },
		{ "sector 56", 102, 103, +0.075, +0.075 },
	};

	// get input
	TFile *f_in = new TFile("distributions.root");

	// ouput file
	TFile *f_out = new TFile("y_alignment_alt.root", "recreate");

	// prepare results
	AlignmentResultsCollection results;

	TF1 *ff = new TF1("ff", "[0] + [1]*(x - [3]) + [2]*(TMath::Erf( (x-[3])/[4] ))");

	// processing
	for (const auto &ad : armData)
	{
		TDirectory *arm_dir = f_out->mkdir(ad.name.c_str());
		
		double y0_N = 0., y0_N_unc = 0., yd_N = 0., yd_N_unc = 0.;
		double y0_F = 0., y0_F_unc = 0., yd_F = 0., yd_F_unc = 0.;

		for (const string rp : { "N", "F"} )
		{
			TDirectory *rp_dir = arm_dir->mkdir(rp.c_str());
			gDirectory = rp_dir;

			printf("* %s, rp %s\n", ad.name.c_str(), rp.c_str());
			
			TProfile *p_y_diffFN_vs_y = (TProfile *) f_in->Get((ad.name + "/near_far/p_y_diffFN_vs_y_" + rp).c_str());

			if (p_y_diffFN_vs_y == NULL)
			{
				printf("    cannot load data, skipping\n");
				continue;
			}

			// TODO
			//double p0_init = input_alignments[ad.rp_id_F].sh_y - input_alignments[ad.rp_id_N].sh_y;;
			double p0_init = 0.;
			double p1_init = 0.10;
			double p2_init = 0.07;
			double p3_init = (rp == "N") ? 0. : 0.;
			double p4_init = (rp == "N") ? 0.3 : 0.6;

			ff->SetParameters(p0_init, p1_init, p2_init, p3_init, p4_init);

			double x_min, x_max;

			x_min = ff->GetParameter(3.) - 3.; x_max = ff->GetParameter(3.) + 3.;
			ff->FixParameter(3, p3_init);
			p_y_diffFN_vs_y->Fit(ff, "Q", "", x_min, x_max);
			ff->ReleaseParameter(3);
			p_y_diffFN_vs_y->Fit(ff, "Q", "", x_min, x_max);

			x_min = ff->GetParameter(3.) - 3.; x_max = ff->GetParameter(3.) + 3.;
			p_y_diffFN_vs_y->Fit(ff, "Q", "", x_min, x_max);
			p_y_diffFN_vs_y->Fit(ff, "Q", "", x_min, x_max);

			p_y_diffFN_vs_y->Write("p_y_diffFN_vs_y");

			if (rp == "N") y0_N = ff->GetParameter(3), y0_N_unc = ff->GetParError(3), yd_N = ff->GetParameter(0), yd_N_unc = ff->GetParError(0);
			if (rp == "F") y0_F = ff->GetParameter(3), y0_F_unc = ff->GetParError(3), yd_F = ff->GetParameter(0), yd_F_unc = ff->GetParError(0);
		}

		printf("* %s\n", ad.name.c_str());

		printf("    N: y0 = %.3f +- %.3f, yd = %.3f +- %.3f\n", y0_N, y0_N_unc, yd_N, yd_N_unc);
		printf("    F: y0 = %.3f +- %.3f, yd = %.3f +- %.3f\n", y0_F, y0_F_unc, yd_F, yd_F_unc);
		printf("    F - N: y0 = %.3f\n", y0_F - y0_N);

		const double c = ((yd_N + yd_F) / 2. - (y0_F - y0_N) ) / 2.;
		const double sh_y_N = y0_N - c + ad.corr_N;
		const double sh_y_F = y0_F + c + ad.corr_F;

		printf("    sh_y_N = %.3f, sh_y_F = %.3f\n", sh_y_N, sh_y_F);

		results["y_alignment_alt"][ad.rp_id_N] = AlignmentResult(0., 0., sh_y_N, y0_N_unc, 0., 0.);
		results["y_alignment_alt"][ad.rp_id_F] = AlignmentResult(0., 0., sh_y_F, y0_F_unc, 0., 0.);
	}

	// write results
	results.Write("y_alignment_alt.out");

	// clean up
	delete f_out;
	return 0;
}
