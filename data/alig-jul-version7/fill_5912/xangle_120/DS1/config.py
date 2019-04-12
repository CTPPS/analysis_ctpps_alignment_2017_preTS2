import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("./"))
sys.path.append(os.path.relpath("../../../../../"))

from config_base import config
from input_files import input_files

config.fill = 5912
config.xangle = 120
config.dataset = "DS1"

config.input_files = input_files

config.aligned = True

config.sector_45.cut_h_c = -0.07
config.sector_45.cut_v_c = +0.22

config.sector_56.cut_h_c = +0.07
config.sector_56.cut_v_c = 0.09

config.matching_1d.rp_L_2_F.x_min = 2.0
config.matching_1d.rp_L_2_F.x_max = 4.8

config.matching_1d.rp_L_1_F.x_min = 2.3
config.matching_1d.rp_L_1_F.x_max = 4.8

config.matching_1d.rp_R_1_F.x_min = 2.0
config.matching_1d.rp_R_1_F.x_max = 3.6

config.matching_1d.rp_R_2_F.x_min = 2.0
config.matching_1d.rp_R_2_F.x_max = 3.4

config.x_alignment_meth_o.rp_L_2_F.x_min = 2.7
config.x_alignment_meth_o.rp_L_2_F.x_max = 15.

config.x_alignment_meth_o.rp_L_1_F.x_min = 2.8
config.x_alignment_meth_o.rp_L_1_F.x_max = 15.

config.x_alignment_meth_o.rp_R_1_F.x_min = 2.3
config.x_alignment_meth_o.rp_R_1_F.x_max = 15.

config.x_alignment_meth_o.rp_R_2_F.x_min = 2.5
config.x_alignment_meth_o.rp_R_2_F.x_max = 15.
