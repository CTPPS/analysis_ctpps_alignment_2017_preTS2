import root;
import pad_layout;

string topDir = "../../data/phys/";

string reference = "data_alig_fill_5685_xangle_150_DS1";

string datasets[] = {
	"fill_5839/xangle_150/DoubleEG",
	"fill_5974/xangle_150/DoubleEG",
	"fill_6090/xangle_150/DoubleEG",
	"fill_6155/xangle_150/DoubleEG",
	"fill_6192/xangle_150/DoubleEG",
};

string rps[], rp_labels[];
//rps.push("L_2_F"); rp_labels.push("L-220-fr");
//rps.push("L_1_F"); rp_labels.push("L-210-fr");
rps.push("R_1_F"); rp_labels.push("R-210-fr");
rps.push("R_2_F"); rp_labels.push("R-220-fr");

ySizeDef = 5cm;

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
		NewPad("$x\ung{mm}$", "std.~dev.~of $y\ung{mm}$");
		currentpad.yTicks = RightTicks(0.5, 0.1);

		string p_base = reference + "/" + rps[rpi] + "/method y/c_cmp|";
		draw(RootGetObject(topDir + dataset+"/match.root", p_base + "h_ref_sel"), "d0,eb", black);
		draw(RootGetObject(topDir + dataset+"/match.root", p_base + "h_test_bef"), "d0,eb", blue);
		draw(RootGetObject(topDir + dataset+"/match.root", p_base + "h_test_aft"), "d0,eb", red);

		limits((2, 0), (15, 3), Crop);
	}
}

GShipout(hSkip=1mm, vSkip=1mm);
