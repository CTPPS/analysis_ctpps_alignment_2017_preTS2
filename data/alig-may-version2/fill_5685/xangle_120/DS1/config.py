import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("./"))
sys.path.append(os.path.relpath("../../../../../"))

from config_base import config
from input_files import input_files

config.fill = 5685
config.xangle = 120
config.dataset = "DS1"

config.input_files = input_files

config.sector_45.cut_h_a = -1.01
config.sector_45.cut_h_c = -38.25
config.sector_45.cut_h_si = 0.2

config.sector_56.cut_h_a = -0.99
config.sector_56.cut_h_c = -39.25
config.sector_56.cut_h_si = 0.2

config.matching.reference_datasets = ["data/alig-jul-version7/fill_5912/xangle_120/DS1"]

config.matching_1d.rp_L_2_F.x_min = 45
config.matching_1d.rp_L_2_F.x_max = 63
config.matching.rp_L_2_F.sh_min = -43
config.matching.rp_L_2_F.sh_max = -42

config.matching_1d.rp_L_1_F.x_min = 7
config.matching_1d.rp_L_1_F.x_max = 23
config.matching.rp_L_1_F.sh_min = -5
config.matching.rp_L_1_F.sh_max = -4

config.matching_1d.rp_R_1_F.x_min = 6
config.matching_1d.rp_R_1_F.x_max = 23
config.matching.rp_R_1_F.sh_min = -3.7
config.matching.rp_R_1_F.sh_max = -2.7

config.matching_1d.rp_R_2_F.x_min = 45
config.matching_1d.rp_R_2_F.x_max = 63
config.matching.rp_R_2_F.sh_min = -43
config.matching.rp_R_2_F.sh_max = -42

config.x_alignment_meth_o.rp_L_2_F.x_min = 45.2
config.x_alignment_meth_o.rp_L_2_F.x_max = 57.5

config.x_alignment_meth_o.rp_L_1_F.x_min = 7.2
config.x_alignment_meth_o.rp_L_1_F.x_max = 19.4

config.x_alignment_meth_o.rp_R_1_F.x_min = 5.6
config.x_alignment_meth_o.rp_R_1_F.x_max = 18.3

config.x_alignment_meth_o.rp_R_2_F.x_min = 45.0
config.x_alignment_meth_o.rp_R_2_F.x_max = 57.5
