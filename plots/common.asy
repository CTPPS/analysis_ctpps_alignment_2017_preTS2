real GetMeanHorizontalAlignment(string rp)
{
	// TODO: update
	if (rp == "L_2_F") return -42.0;
	if (rp == "L_1_F") return -3.6;
	if (rp == "R_1_F") return -2.8;
	if (rp == "R_2_F") return -41.9;

	return 0;
}

//----------------------------------------------------------------------------------------------------

real GetMeanHorizontalRelativeAlignment(string sector)
{
	if (sector == "45") return 38.32;
	if (sector == "56") return 39.35;

	return 0;
}

//----------------------------------------------------------------------------------------------------

real GetMeanVerticalAlignment(string rp)
{
	if (rp == "L_2_F") return 3.5;
	if (rp == "L_1_F") return 3.8;
	if (rp == "R_1_F") return 3.75;
	if (rp == "R_2_F") return 3.5;

	return 0;
}

//----------------------------------------------------------------------------------------------------

real GetMeanVerticalRelativeAlignment(string sector)
{
	if (sector == "45") return -0.1;
	if (sector == "56") return -0.1;

	return 0;
}
