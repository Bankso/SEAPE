from matplotlib import pyplot

tfname=str(sys.argv[1])
frags=str(sys.argv[2])

if (tfname=="Abf1"):
    times=["10s", "20s", "60s"]
    for t in times:
        set=str("Abf1/" + t)
        if (frags=="ff"):
            ff_t=str(set + "/plots_full_frag_cent/Abf1_" + t + "_full_frag_ratio_no_clust_1000_1000_Abf1_MA02652_FIMO_E4_sc3_cent")
        if (frags=="sf"):
            sf_t=str(set + "/plots_ChEC_cent/Abf1_" + t + "_ChEC_ratio_no_clust_1000_1000_Abf1_MA02652_FIMO_E4_sc3_cent")
        if (frags=="lf"):
            lf_t=str(set + "/plots_MNase_cent/Abf1_" + t + "_MNase_ratio_no_clust_1000_1000_Abf1_MA02652_FIMO_E4_sc3_cent")
        t_frags=[ff_t/*.tsv, ]
    colours = ["blue", "red", "red"]
    for data, colour in zip(allData, colours):
        pyplot.plot(depth, data, color=colour)

    pyplot.show()

if (tfname=="Reb1"):
    times=["5s", "20s", "60s"]
    for t in times:
    t_set=str("Reb1/" + t)
    ff_t=str(t_set + "/plots_full_frag_cent/")
    sf_t=str(t_set + "/plots_ChEC_cent/")
    lf_t=str(t_set + "/plots_MNase_cent/")

#Make some data
depth = range(500)
allData = zip(*[[x, 2*x, 3*x] for x in depth])

#Set out colours
