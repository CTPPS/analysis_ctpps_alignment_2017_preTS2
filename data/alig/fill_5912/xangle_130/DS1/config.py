import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("./"))
sys.path.append(os.path.relpath("../../../../../"))

from config_base import config
from input_files import input_files

config.input_files = input_files

config.sector_45.cut_h_a = -1.01
config.sector_45.cut_h_c = -38.25
config.sector_45.cut_h_si = 0.2

config.sector_56.cut_h_a = -0.99
config.sector_56.cut_h_c = -39.25
config.sector_56.cut_h_si = 0.2
