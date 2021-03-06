import root;
import pad_layout;

string topDir = "../../data/phys-version1/";

string reference = "data_alig-may-version3-aligned_fill_5685_xangle_150_DS1";

string datasets[] = {
	"fill_5839/xangle_150/ALL",
	"fill_5974/xangle_150/ALL",
	"fill_6090/xangle_150/ALL",
	"fill_6155/xangle_150/ALL",
	"fill_6192/xangle_150/ALL",
};

string rps[], rp_labels[];
rps.push("L_2_F"); rp_labels.push("L-220-fr");
rps.push("L_1_F"); rp_labels.push("L-210-fr");
rps.push("R_1_F"); rp_labels.push("R-210-fr");
rps.push("R_2_F"); rp_labels.push("R-220-fr");

ySizeDef = 5cm;

xTicksDef = LeftTicks(3., 1.);

//----------------------------------------------------------------------------------------------------

NewPad();
for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

for (int dsi : datasets.keys)
{
	string dataset = datasets[dsi];

	NewRow();
	NewPadLabel(replace(dataset, "_", "\_"));

	for (int rpi : rps.keys)
	{
		NewPad("$x\ung{mm}$", "entries (normalised)");
		//currentpad.yTicks = RightTicks(0.5, 0.1);

		string f = topDir + dataset+"/match.root";
		string p_base = reference + "/" + rps[rpi] + "/method x/c_cmp";
		RootObject obj_base = RootGetObject(f, p_base, error=false);
		if (!obj_base.valid)
			continue;

		draw(RootGetObject(f, p_base + "|h_ref_sel"), "d0,eb", black);
		draw(RootGetObject(f, p_base + "|h_test_bef"), "d0,eb", blue);
		draw(RootGetObject(f, p_base + "|h_test_aft"), "d0,eb", red);

		//limits((2, 0), (15, 3.5), Crop);
		xlimits(3, 16, Crop);
	}
}

GShipout("al_hor_meth_x_details_cmp_fill", hSkip=1mm, vSkip=1mm);
