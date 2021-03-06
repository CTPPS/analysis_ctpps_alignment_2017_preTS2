import root;
import pad_layout;

include "../common.asy";

string topDir = "../../data/phys-version1/";

include "../fills_samples.asy";
InitDataSets();

//----------------------------------------------------------------------------------------------------

string sample_labels[];
pen sample_pens[];
//sample_labels.push("ZeroBias"); sample_pens.push(blue);
//sample_labels.push("DoubleEG"); sample_pens.push(magenta);
//sample_labels.push("SingleMuon"); sample_pens.push(heavygreen);
sample_labels.push("ALL"); sample_pens.push(red);

real sfa = 0.3;

string method = "method o";

//int xangle = 120;
//string ref_label = "data_alig-may-version3-aligned_fill_5685_xangle_120_DS1";
int xangle = 150;
string ref_label = "data_alig-may-version3-aligned_fill_5685_xangle_150_DS1";

int rp_ids[];
string rps[], rp_labels[];
real rp_shift_m[];
rp_ids.push(23); rps.push("L_2_F"); rp_labels.push("L-220-fr"); rp_shift_m.push(-42.05);
rp_ids.push(3); rps.push("L_1_F"); rp_labels.push("L-210-fr"); rp_shift_m.push(-3.7);
rp_ids.push(103); rps.push("R_1_F"); rp_labels.push("R-210-fr"); rp_shift_m.push(-2.75);
rp_ids.push(123); rps.push("R_2_F"); rp_labels.push("R-220-fr"); rp_shift_m.push(-42.05);

yTicksDef = RightTicks(0.2, 0.1);

xSizeDef = 40cm;

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

AddToLegend("(" + method + ")");
AddToLegend(format("(xangle %u)", xangle));

for (int sai : sample_labels.keys)
{
	AddToLegend(sample_labels[sai], sample_pens[sai]);
}

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	write(rps[rpi]);

	NewRow();

	NewPad("fill", "horizontal shift$\ung{mm}$");
	
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
	
			for (int sai : sample_labels.keys)
			{
				string f = topDir + dataset + "/" + sample_labels[sai] + "/x_alignment_meth_o.root";	
				RootObject obj = RootGetObject(f, ref_label + "/" + rps[rpi] + "/g_results", error = false);
	
				if (!obj.valid)
					continue;
	
				real ax[] = { 0. };
				real ay[] = { 0. };
				obj.vExec("GetPoint", 0, ax, ay); real bsh = ax[0], bsh_unc = ay[0];

				real x = fdi;
				if (sample_labels.length > 1)
					x += sai * sfa / (sample_labels.length - 1) - sfa/2;

				bool pointValid = (bsh == bsh && bsh_unc == bsh_unc && fabs(bsh) > 0.);
	
				pen p = sample_pens[sai];
	
				if (pointValid)
				{
					draw((x, bsh), m + p);
					draw((x, bsh-bsh_unc)--(x, bsh+bsh_unc), p);
				}
			}
		}
	}

	real y_mean = GetMeanHorizontalAlignment(rps[rpi]);
	draw((-1, y_mean)--(fill_data.length, y_mean), black);

	//xlimits(-1, fill_data.length, Crop);
	limits((-1, y_mean-1), (fill_data.length, y_mean+1), Crop);

	AttachLegend("{\SetFontSizesXX " + rp_labels[rpi] + "}");
}

//----------------------------------------------------------------------------------------------------

GShipout("al_hor_meth_o_cmp_sample", hSkip=5mm, vSkip=1mm);
