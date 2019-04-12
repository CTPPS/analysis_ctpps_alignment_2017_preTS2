import root;
import pad_layout;

string topDir = "../../data/alig-may-version3/";

string dataset = "fill_5685/xangle_120/DS1";

string dir = "sector 45/near_far/p_y_diffFN_vs_y_N, x slices";

string slices[] = {
	"6.7-6.9",
	"10.7-10.9",
	"13.7-13.9",
};

//ySizeDef = 5cm;


//----------------------------------------------------------------------------------------------------

for (int sli : slices.keys)
{
	NewPad("$y_N\ung{mm}$", "$y_F - y_N\ung{mm}$");

	draw(RootGetObject(topDir + dataset + "/distributions.root", dir + "/" + slices[sli]), "vl,eb", red);

	limits((1, -0.8), (8, 0.2), Crop);

	AttachLegend("x: " + slices[sli]);
}

GShipout("al_hor_meth_o_fit_details", hSkip=1mm, vSkip=1mm);
