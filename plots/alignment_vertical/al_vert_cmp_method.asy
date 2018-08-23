import root;
import pad_layout;

string topDir = "../../data/phys/";

include "../fills_samples.asy";
InitDataSets();

//----------------------------------------------------------------------------------------------------

pen p_meth_fit = red;
pen p_meth_s_curve = blue;

string sample = "DoubleEG";
//string sample = "SingleMuon";
//string sample = "ZeroBias";

int xangle = 150;

real sfa = 0.3;

int rp_ids[];
string rps[], rp_labels[], rp_dirs[];
real rp_y_min[], rp_y_max[];
rp_ids.push(23); rps.push("L_2_F"); rp_labels.push("L-220-fr"); rp_y_min.push(3); rp_y_max.push(4); rp_dirs.push("sector 45/F");
rp_ids.push(3); rps.push("L_1_F"); rp_labels.push("L-210-fr"); rp_y_min.push(3); rp_y_max.push(4); rp_dirs.push("sector 45/N");
rp_ids.push(103); rps.push("R_1_F"); rp_labels.push("R-210-fr"); rp_y_min.push(3); rp_y_max.push(4); rp_dirs.push("sector 56/N");
rp_ids.push(123); rps.push("R_2_F"); rp_labels.push("R-220-fr"); rp_y_min.push(3); rp_y_max.push(4); rp_dirs.push("sector 56/F");

xSizeDef = 40cm;

//yTicksDef = RightTicks(0.01, 0.005);

//----------------------------------------------------------------------------------------------------

string TickLabels(real x)
{
	if (x >=0 && x < fill_data.length)
	{
		return format("%i", fill_data[(int) x].fill);
	} else {
		return "";
	}
}

xTicksDef = LeftTicks(rotate(90)*Label(""), TickLabels, Step=1, step=0);

//----------------------------------------------------------------------------------------------------

NewPad(false, 1, 1);

AddToLegend(format("xangle = %u", xangle));

AddToLegend("method ``fit''", mCi+3pt+p_meth_fit);
AddToLegend("method ``s-curve''", mCi+3pt+p_meth_s_curve);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	write(rps[rpi]);

	//if (rpi == 2)
		NewRow();

	NewPad("fill", "vertical shift $\ung{mm}$");

	for (int fdi : fill_data.keys)
	{
		write(format("    %i", fill_data[fdi].fill));

		int fill = fill_data[fdi].fill; 
		int rp_id = rp_ids[rpi];

		for (int dsi : fill_data[fdi].datasets.keys)
		{
			if (fill_data[fdi].datasets[dsi].xangle != xangle)
				continue;

			string dataset = fill_data[fdi].datasets[dsi].tag;

			write("        " + dataset);
	
			mark m = mCi+3pt;

			{
				real x = fdi;

				mark m = mCi+3pt;

				// "fit" method
				string f = topDir + dataset + "/" + sample + "/y_alignment.root";
				RootObject results = RootGetObject(f, rps[rpi] + "/g_results", error = false);
		
				if (results.valid)
				{
					real ax[] = {0.};
					real ay[] = {0.};
					results.vExec("GetPoint", 0, ax, ay); real sh_x = ax[0];
					results.vExec("GetPoint", 1, ax, ay); real a = ax[0], a_unc = ay[0];
					results.vExec("GetPoint", 2, ax, ay); real b = ax[0], b_unc = ay[0];
					results.vExec("GetPoint", 3, ax, ay); real b_fs = ax[0], b_fs_unc = ay[0];

					draw((x, b), m + p_meth_fit);
					draw((x, b - b_unc)--(x, b + b_unc), p_meth_fit);
				}

				// get "s curve" method result

				string f = topDir + dataset + "/" + sample + "/y_alignment_alt.root";
				RootObject fit = RootGetObject(f, rp_dirs[rpi] + "/p_y_diffFN_vs_y|ff", error=false);
		
				if (fit.valid)
				{
					real p3 = fit.rExec("GetParameter", 3);
					real p3_unc = fit.rExec("GetParError", 3);

					draw((x, p3), m + p_meth_s_curve);
					draw((x, p3 - p3_unc)--(x, p3 + p3_unc), p_meth_s_curve);
				}
			}
		}
	}

	limits((-1, rp_y_min[rpi]), (fill_data.length, rp_y_max[rpi]), Crop);

	AttachLegend("{\SetFontSizesXX " + rp_labels[rpi] + "}");
}

//----------------------------------------------------------------------------------------------------

GShipout(hSkip=5mm, vSkip=1mm);
