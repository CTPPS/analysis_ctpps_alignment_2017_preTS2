import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("../../../../../"))

from config_base import config

config.sector_45.cut_h_c = -38.4

config.sector_56.cut_h_c = -39.3

config.matching_1d.rp_L_2_F.x_min = 46.2
config.matching_1d.rp_L_2_F.x_max = 53

config.matching_1d.rp_L_1_F.x_min = 8.0
config.matching_1d.rp_L_1_F.x_max = 13

config.matching_1d.rp_R_1_F.x_min = 6.0
config.matching_1d.rp_R_1_F.x_max = 10

config.matching_1d.rp_R_2_F.x_min = 45.3
config.matching_1d.rp_R_2_F.x_max = 49
