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

config.aligned = True

config.alignment_corrections.rp_L_2_F.de_x = -42.525
config.alignment_corrections.rp_L_1_F.de_x = -4.4
config.alignment_corrections.rp_R_1_F.de_x = -3.275
config.alignment_corrections.rp_R_2_F.de_x = -42.475

config.sector_45.cut_h_a = -1.007
config.sector_45.cut_h_c = -0.20

config.sector_56.cut_h_a = -0.983
config.sector_56.cut_h_c = -0.09

config.sector_45.nr_x_slice_min = 2
config.sector_45.nr_x_slice_max = 22
config.sector_45.fr_x_slice_min = 2
config.sector_45.fr_x_slice_max = 22
config.sector_56.nr_x_slice_min = 2
config.sector_56.nr_x_slice_max = 22
config.sector_56.fr_x_slice_min = 2
config.sector_56.fr_x_slice_max = 22

config.matching.reference_datasets = cms.vstring("data/alig/fill_5912/xangle_120/DS1")

config.matching.rp_L_2_F.sh_min = -0.5
config.matching.rp_L_2_F.sh_max = +0.5

config.matching.rp_L_1_F.sh_min = -0.5
config.matching.rp_L_1_F.sh_max = +0.5

config.matching.rp_R_1_F.sh_min = -0.5
config.matching.rp_R_1_F.sh_max = +0.5

config.matching.rp_R_2_F.sh_min = -0.5
config.matching.rp_R_2_F.sh_max = +0.5

config.matching_1d.rp_L_2_F.x_min = 2.3
config.matching_1d.rp_L_2_F.x_max = 21

config.matching_1d.rp_L_1_F.x_min = 2.5
config.matching_1d.rp_L_1_F.x_max = 21

config.matching_1d.rp_R_1_F.x_min = 2.3
config.matching_1d.rp_R_1_F.x_max = 21

config.matching_1d.rp_R_2_F.x_min = 2.5
config.matching_1d.rp_R_2_F.x_max = 21

config.x_alignment_meth_o.rp_L_2_F.x_min = 5.
config.x_alignment_meth_o.rp_L_2_F.x_max = 12.

config.x_alignment_meth_o.rp_L_1_F.x_min = 5.
config.x_alignment_meth_o.rp_L_1_F.x_max = 12.

config.x_alignment_meth_o.rp_R_1_F.x_min = 4.
config.x_alignment_meth_o.rp_R_1_F.x_max = 9.

config.x_alignment_meth_o.rp_R_2_F.x_min = 4.
config.x_alignment_meth_o.rp_R_2_F.x_max = 9.
