#include "config.h"
#include "stat.h"
#include "alignment_classes.h"

#include "TFile.h"
#include "TH1D.h"
#include "TGraphErrors.h"
#include "TCanvas.h"
#include "TF1.h"
#include "TProfile.h"
#include "TKey.h"

#include <vector>
#include <string>

using namespace std;

//----------------------------------------------------------------------------------------------------

string ReplaceAll(const string &str, const string &from, const string &to)
{
	string output(str);

    size_t start_pos = 0;
    while ((start_pos = str.find(from, start_pos)) != string::npos)
	{
        output.replace(start_pos, from.length(), to);
        start_pos += to.length();
    }

    return output;
}

//----------------------------------------------------------------------------------------------------

TF1 *ff = new TF1("ff", "[0] + [1]*x");

TGraphErrors* BuildGraphFromDirectory(TDirectory *dir)
{
	TGraphErrors *g = new TGraphErrors();

	TIter next(dir->GetListOfKeys());
	TObject *o;
	while ((o = next()))
	{
		TKey *k = (TKey *) o;

		string name = k->GetName();
		size_t d = name.find("-");
		const double x_min = atof(name.substr(0, d).c_str());
		const double x_max = atof(name.substr(d+1).c_str());

		//printf("  %s, %.3f, %.3f\n", name.c_str(), x_min, x_max);

		TProfile *p = (TProfile *) k->ReadObj();
		ff->SetParameter(0., 0.);
		p->Fit(ff, "Q", "");

		int idx = g->GetN();
		g->SetPoint(idx, (x_max + x_min)/2., ff->GetParameter(1));
		g->SetPointError(idx, (x_max - x_min)/2., ff->GetParError(1));
	}

	return g;
}

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
	struct RPData
	{
		string name;
		unsigned int id;
		string sectorName;
		string position;
	};

	vector<RPData> rpData = {
		{ "L_2_F", 23,  "sector 45", "F" },
		{ "L_1_F", 3,   "sector 45", "N" },
		{ "R_1_F", 103, "sector 56", "N" },
		{ "R_2_F", 123, "sector 56", "F" }
	};

	// get input
	TFile *f_in = new TFile("distributions.root");

	// ouput file
	TFile *f_out = new TFile("x_alignment_meth_o.root", "recreate");

	// prepare results
	AlignmentResultsCollection results;

	// processing
	for (auto ref : cfg.matching_1d_reference_datasets)
	{
		/*
		if (ref == "default")
		{
			char buf[100];
			sprintf(buf, "data/alig/fill_6228/xangle_%u/DS1", cfg.xangle);
			ref = buf;
		}
		*/

		printf("-------------------- reference dataset: %s\n", ref.c_str());

		const string &ref_tag = ReplaceAll(ref, "/", "_");
		TDirectory *ref_dir = f_out->mkdir(ref_tag.c_str());
	
		const string ref_path = "../../../../../" + ref;
		TFile *f_ref = TFile::Open((ref_path + "/distributions.root").c_str());

		Config cfg_ref;
		cfg_ref.LoadFrom(ref_path + "/config.py");

		for (const auto &rpd : rpData)
		{
			printf("* %s\n", rpd.name.c_str());

			TDirectory *rp_dir = ref_dir->mkdir(rpd.name.c_str());
			
			// TODO
			//TDirectory *d_ref = (TDirectory *) f_ref->Get((rpd.sectorName + "/near_far/p_y_diffFN_vs_y_" + rpd.position + ", x slices").c_str());
			TDirectory *d_test = (TDirectory *) f_in->Get((rpd.sectorName + "/near_far/p_y_diffFN_vs_y_" + rpd.position + ", x slices").c_str());

			TGraphErrors *g_test = BuildGraphFromDirectory(d_test);

			gDirectory = rp_dir;
			g_test->Write("g_test");

			// TODO: do match

			// TODO: save results
			//results[ref + ", method y"][rpd.id] = AlignmentResult(r_method_y);
		}
		
		delete f_ref;
	}

	// write results
	FILE *f_results = fopen("x_alignment_meth_o.out", "w"); 
	results.Write(f_results);
	fclose(f_results);

	// clean up
	delete f_out;
	return 0;
}
