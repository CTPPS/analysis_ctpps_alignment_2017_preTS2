import FWCore.ParameterSet.Config as cms

config = cms.PSet(
    fill = cms.uint32(0),
    xangle = cms.uint32(0),
    dataset = cms.string(""),

    alignment_corrections = cms.PSet(
      rp_L_2_F = cms.PSet(
        de_x = cms.double(0.)
      ),
      rp_L_1_F = cms.PSet(
        de_x = cms.double(0.)
      ),
      rp_R_1_F = cms.PSet(
        de_x = cms.double(0.)
      ),
      rp_R_2_F = cms.PSet(
        de_x = cms.double(0.)
      )
    ),

    aligned = cms.bool(False),

    n_si = cms.double(4.),

    sector_45 = cms.PSet(
      cut_h_apply = cms.bool(True),
      cut_h_a = cms.double(-1),
      cut_h_c = cms.double(0),
      cut_h_si = cms.double(0.2),

      cut_v_apply = cms.bool(False),
      cut_v_a = cms.double(-1.1),
      cut_v_c = cms.double(0.9),
      cut_v_si = cms.double(0.5),
    ),

    sector_56 = cms.PSet(
      cut_h_apply = cms.bool(True),
      cut_h_a = cms.double(-1),
      cut_h_c = cms.double(0),
      cut_h_si = cms.double(0.2),

      cut_v_apply = cms.bool(False),
      cut_v_a = cms.double(-1.1),
      cut_v_c = cms.double(0.8),
      cut_v_si = cms.double(0.5),
    ),

    matching_1d = cms.PSet(
      reference_datasets = cms.vstring(),

      rp_L_2_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-44),
        sh_max = cms.double(-40)
      ),
      rp_L_1_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-5),
        sh_max = cms.double(-1)
      ),
      rp_R_1_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-5),
        sh_max = cms.double(-1)
      ),
      rp_R_2_F = cms.PSet(
        x_min = cms.double(0.),
        x_max = cms.double(0.),
        sh_min = cms.double(-44),
        sh_max = cms.double(-40)
      )
    ),

    alignment_y = cms.PSet(
      rp_L_2_F = cms.PSet(
        x_min = cms.double(46.5),
        x_max = cms.double(57.),
      ),
      rp_L_1_F = cms.PSet(
        x_min = cms.double(8.),
        x_max = cms.double(18.),
      ),
      rp_R_1_F = cms.PSet(
        x_min = cms.double(7.5),
        x_max = cms.double(18.),
      ),
      rp_R_2_F = cms.PSet(
        x_min = cms.double(47.),
        x_max = cms.double(57.),
      )
    )
)
