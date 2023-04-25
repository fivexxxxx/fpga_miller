add wave -divider {tb_miller}
#add wave -position insertpoint sim:/tb_dds_da/*

#add wave -divider {u_Miller_top}
#add wave -position insertpoint sim:/tb_miller/u_Miller_top/*

add wave -position insertpoint  \
sim:/tb_miller/clk
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Bit_out
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Bit_out_valid
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Bit_out_tready
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_BitOut
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_tx/clk_cnt
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_tx/send_tmp
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_rx/Bit_in
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_rx/Bit_in_valid
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_rx/clk_cnt
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_rx/bit_cnt
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_rx/Miller_BitIn_tmp
add wave -position insertpoint  \
sim:/tb_miller/u_Miller_top/Miller_rx/Bit_sync