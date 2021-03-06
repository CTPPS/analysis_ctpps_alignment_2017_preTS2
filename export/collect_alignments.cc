#include "../alignment_classes.h"
#include "fills_runs.h"

using namespace std;

//----------------------------------------------------------------------------------------------------

struct RPData
{
	unsigned int n = 0;
	double sxw_x_meth_o = 0., sw_x_meth_o = 0.;
	double sxw_x_rel = 0., sw_x_rel = 0.;
	double sxw_y = 0., sw_y = 0.;
	double sxw_y_meth_s = 0., sw_y_meth_s = 0.;
};

//----------------------------------------------------------------------------------------------------

int main()
{
	// initialisation
	InitFillsRuns();
	//PrintFillRunMapping();

	string topDir = "../data/phys-version1";

	vector<string> xangles = {
		"xangle_150",
		"xangle_120",
	};

	vector<string> datasets = {
		"ALL"
		//"DoubleEG",
		//"SingleMuon",
		//"ZeroBias",
	};

	struct ArmData {
		string name;
		unsigned int rp_id_N, rp_id_F;
	};

	vector<ArmData> armData = {
		{ "sector 45", 3, 23 },
		{ "sector 56", 103, 123 },
	};

	vector<unsigned int> rps;
 	for (const auto &ad : armData)
	{
		rps.push_back(ad.rp_id_N);
		rps.push_back(ad.rp_id_F);
	}

	// prepare output
	AlignmentResultsCollection output;

	// process all fills
	for (const auto &fill : fills)
	{
		//printf("---------------\n");

		// collect data from all xangles, datasets and RPs
		map<unsigned int, RPData> rpData;

		for (const auto &xangle : xangles)
		{
			for (const auto &dataset : datasets)
			{
				vector<unsigned int> rpsWithMissingData;
				for (const auto &rp : rps)
				{
					bool rp_sector_45 = (rp / 100 == 0);
					unsigned int reference_fill = (rp_sector_45) ? fills_reference[fill].sector45 : fills_reference[fill].sector56;

					//printf("fill %u, RP %u --> ref fill %u\n", fill, rp, reference_fill);

					// path base
					char buf[100];
					sprintf(buf, "%s/fill_%u", topDir.c_str(), reference_fill);

					// try to get input
					string dir = string(buf) + "/" + xangle + "/" + dataset;
					signed int r = 0;

					AlignmentResultsCollection arc_x_method_o;
					r += 1 * arc_x_method_o.Load(dir + "/x_alignment_meth_o.out");

					AlignmentResultsCollection arc_x_rel;
					r += 2 * arc_x_rel.Load(dir + "/x_alignment_relative.out");

					AlignmentResultsCollection arc_y;
					r += 4 * arc_y.Load(dir + "/y_alignment.out");

					//AlignmentResultsCollection arc_y_method_s;
					//r += arc_y_method_s.Load(dir + "/y_alignment_alt.out");

					// check all input available
					if (r != 0)
					{
						//printf("WARNING: some input files invailable in directory '%s'.\n", dir.c_str());
						continue;
					}

					// extract corrections
					const AlignmentResults &ar_x_method_o = arc_x_method_o["x_alignment_meth_o"];
					const AlignmentResults &ar_x_rel = arc_x_rel["x_alignment_relative_sl_fix"];
					const AlignmentResults &ar_y = arc_y["y_alignment_sl_fix"];
					//const AlignmentResults &ar_y_method_s = arc_y_method_s["y_alignment_alt"];

					bool found = true;

					auto rit_x_method_o = ar_x_method_o.find(rp);
					if (rit_x_method_o == ar_x_method_o.end())
						found = false;

					auto rit_x_rel = ar_x_rel.find(rp);
					if (rit_x_rel == ar_x_rel.end())
						found = false;

					auto rit_y = ar_y.find(rp);
					if (rit_y == ar_y.end())
						found = false;

					//auto rit_y_method_s = ar_y_method_s.find(rp);
					//if (rit_y_method_s == ar_y_method_s.end())
					//	found = false;

					if (!found)
					{
						rpsWithMissingData.push_back(rp);
						continue;
					}

					double w;
					auto &d = rpData[rp];

					d.n++;

					w = 1. / pow(rit_x_method_o->second.sh_x_unc, 2.);
					d.sw_x_meth_o += w;
					d.sxw_x_meth_o += rit_x_method_o->second.sh_x * w;

					//w = 1. / pow(rit_x_rel->second.sh_x_unc, 2.);
					w = 1. / pow(0.010, 2.);
					d.sw_x_rel += w;
					d.sxw_x_rel += rit_x_rel->second.sh_x * w;

					w = 1. / pow(rit_y->second.sh_y_unc, 2.);
					d.sw_y += w;
					d.sxw_y += rit_y->second.sh_y * w;

					//w = 1. / pow(rit_y_method_s->second.sh_y_unc, 2.);
					//d.sw_y_meth_s += w;
					//d.sxw_y_meth_s += rit_y_method_s->second.sh_y * w;
				}

				if (!rpsWithMissingData.empty())
				{
					printf("WARNING: some constantants missing for fill %u, xangle %s, dataset %s and RPs: ", fill, xangle.c_str(), dataset.c_str());
					for (const auto &rp : rpsWithMissingData)
						printf("%u, ", rp);
					printf("\n");
				}
			}
		}

		// process data from all RPs
		AlignmentResults ars_combined;

		vector<unsigned int> rpsWithNoData;

		for (const auto &ad : armData)
		{
			auto &d_N = rpData[ad.rp_id_N];
			auto &d_F = rpData[ad.rp_id_F];

			bool stop = false;

			if (d_N.n == 0)
			{
				rpsWithNoData.push_back(ad.rp_id_N);
				stop = true;
			}

			if (d_F.n == 0)
			{
				rpsWithNoData.push_back(ad.rp_id_F);
				stop = true;
			}

			if (stop)
				continue;

			// b = mean (x_F - x_N) with no correction
			const double de_x_N = d_N.sxw_x_meth_o / d_N.sw_x_meth_o;
			const double de_x_F = d_F.sxw_x_meth_o / d_F.sw_x_meth_o;

			const double b = d_N.sxw_x_rel / d_N.sw_x_rel - d_F.sxw_x_rel / d_F.sw_x_rel;
			const double x_corr_rel = b + de_x_F - de_x_N;

			double x_corr_N = 0., x_corr_F = 0.;
			if (ad.name == "sector 45") x_corr_N = +52E-3 - 80E-3/2., x_corr_F = -52E-3 + 80E-3/2.;
			if (ad.name == "sector 56") x_corr_N = +58E-3 - 82E-3/2., x_corr_F = -58E-3 + 82E-3/2.;

			double y_corr_N = 0., y_corr_F = 0.;
			if (ad.name == "sector 45") y_corr_N += +35E-3 - 25E-3, y_corr_F += -35E-3 + 25E-3;
			if (ad.name == "sector 56") y_corr_N += +110E-3 - 25E-3, y_corr_F += 0E-3 + 25E-3;

			AlignmentResult ar_N(de_x_N + x_corr_rel/2. + x_corr_N, 150E-3, d_N.sxw_y / d_N.sw_y + y_corr_N, 150E-3);
			AlignmentResult ar_F(de_x_F - x_corr_rel/2. + x_corr_F, 150E-3, d_F.sxw_y / d_F.sw_y + y_corr_F, 150E-3);

			ars_combined[ad.rp_id_N] = ar_N;
			ars_combined[ad.rp_id_F] = ar_F;
		}

		if (!rpsWithNoData.empty())
		{
			printf("ERROR: fill %u has RPs with no data: ", fill);
			for (const auto &rp : rpsWithNoData)
				printf("%u, ", rp);
			printf("\n");
		}

		char buf[50];
		sprintf(buf, "fill %u", fill);
		output[buf] = ars_combined;
	}

	// save results
	output.Write("collect_alignments_2020_04_29.out");

	// clean up
	return 0;
}
