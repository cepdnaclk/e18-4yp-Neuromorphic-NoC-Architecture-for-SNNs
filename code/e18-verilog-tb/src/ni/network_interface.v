//  This module is the interface between the accelerator and the network
/*
    The module includes, 
    1. CSR fanout matrix -> This in a utils file. (DONE)
    2. Accelerator to router mapping. -> (Not right now)
    3. Decide whether a packet needs to be created or whether the spike resolution remains 
       within the accelerator
    4. Need to have an input and output buffer
    5. Receive spikes and send out spikes.

*/

`include "ni_utils/fanout_mem.v"

module network_interface(
    input [NUM_BITS_ADDR-1:0] source_neuron_address,
    output reg stays
);
    parameter NUM_BITS_ADDR = 12;
    parameter NUM_CONNECTIONS = 5;

    wire [NUM_BITS_ADDR*NUM_CONNECTIONS-1:0] dest_addr;

    // Call the utils fanout memory file 
    fanout_mem f1(source_neuron_address, dest_addr);
    /*  Check the most significant 2 bits of the address
            -> If 00 -> remain within the accelerator
            -> Else -> create packet to send to Network
    */

    // Print the outputs whenever the inputs change
    always@(dest_addr)
    begin
        $display($time, "  dest_addr[59:58]: %b     dest_addr[47:46]: %b    dest_addr[35:34]: %b    dest_addr[23:22]: %b    dest_addr[11:10]: %b", dest_addr[59:58], dest_addr[47:46], dest_addr[35:34], dest_addr[23:22], dest_addr[11:10]);
    end

    always@(dest_addr)begin 
        if (dest_addr[59:58] == 2'b00 and dest_addr[47:46] == 2'b00 and dest_addr[35:34] == 2'b00 and dest_addr[23:22] == 2'b00 and dest_addr[11:10] == 2'b00) stays = 1'd1;
    end



endmodule

