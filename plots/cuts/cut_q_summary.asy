import root;
import pad_layout;

include "../fills_samples.asy";
InitDataSets();
//AddDataSet("fill_6371/xangle_130");

string topDir = "../../";

string sectors[];
sectors.push("sector 45");
sectors.push("sector 56");

string cuts[], c_labels[];
real c_ranges[], c_Ticks[], c_ticks[];
cuts.push("cut_h"); c_labels.push("cut h"); c_ranges.push(0.4); c_Ticks.push(0.10); c_ticks.push(0.05);
cuts.push("cut_v"); c_labels.push("cut v"); c_ranges.push(0.2); c_Ticks.push(0.05); c_ticks.push(0.01);

string dataset = "DoubleEG";

xSizeDef = 8cm;

//----------------------------------------------------------------------------------------------------

pen XangleColor(int xangle)
{
	if (xangle == 110) return red;
	if (xangle == 130) return blue;
	if (xangle == 150) return heavygreen;

	return black;
}

//----------------------------------------------------------------------------------------------------

NewPad(false);

for (int sci : sectors.keys)
{
	for (int cti : cuts.keys)
	{
		NewPad(false);
		label("\vbox{\SetFontSizesXX\hbox{"+sectors[sci]+"}\hbox{"+c_labels[cti]+"}}");
	}
}

for (int fi : fill_data.keys)
{
	int fill = fill_data[fi].fill;
	
	if (fill != 6371)
		continue;
	
	NewRow();

	NewPad(false);
	label("\vbox{\SetFontSizesXX \hbox{"+format("%u", fill)+"}}");
	
	for (int sci : sectors.keys)
	{
		for (int cti : cuts.keys)
		{
			NewPad();
			currentpad.xTicks = LeftTicks(c_Ticks[cti], c_ticks[cti]);
			
			real r = c_ranges[cti];

			TH1_x_min = -r;
			TH1_x_max = +r;

			for (int dsi : fill_data[fi].datasets.keys)
			{
				string dir_base = fill_data[fi].datasets[dsi].tag;
				int xangle = fill_data[fi].datasets[dsi].xangle;

				string f = topDir + "data/phys/" + dir_base + "/" + dataset + "/distributions.root";
				string obj_path = sectors[sci] + "/cuts/" + cuts[cti] + "/h_q_" + cuts[cti] + "_aft";

				pen p = XangleColor(xangle);

				RootObject obj = RootGetObject(f, obj_path, error=false);
				if (obj.valid)
					draw(obj, "d0,vl,N", p);	
			}

			xlimits(-r, r, Crop);

			AttachLegend(format("%u", fill), NW, NW);
		}
	}

	if (fi == 0)
	{
		NewPad(false);
		AddToLegend(format("xangle = %u", 110), XangleColor(110));
		AddToLegend(format("xangle = %u", 130), XangleColor(130));
		AddToLegend(format("xangle = %u", 150), XangleColor(150));
		AttachLegend();
	}
}
