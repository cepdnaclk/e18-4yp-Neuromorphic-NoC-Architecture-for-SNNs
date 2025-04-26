

module network_interface_static(
    input wire CLK,            //clock
    input wire clear,          //clear to start timestep
    input wire spike0,    //1 bit wire to get spike information from each of the adders 
    input wire spike1,
    input wire spike2,
    input wire spike3,
    input wire spike4,
    input wire spike5,
    input wire spike6,
    input wire spike7,
    input wire spike8,
    input wire spike9,
    input wire spike10,    //1 bit wire to get spike information from each of the adders 
    input wire spike11,
    input wire spike12,
    input wire spike13,
    input wire spike14,
    input wire spike15,
    input wire spike16,
    input wire spike17,
    input wire spike18,
    input wire spike19,
    input wire[119:0] neuron_addresses_initialization,          //input to initialize the neruon addresses
    input wire[54:0] connection_pointer_initialization,          //input to initialize the connection pointers
    input wire[359:0] downstream_connections_initialization,    //input to initialize the dowanstream connections
    //output reg[23:0] packet               //outgoing packet         
    output reg[11:0] spike_out_source0, spike_out_source1,
        spike_out_source2,    spike_out_source3,    spike_out_source4,    
        spike_out_source5,    spike_out_source6,    spike_out_source7,    
        spike_out_source8,    spike_out_source9,    spike_out_source10,
        spike_out_source11,   spike_out_source12,    spike_out_source13,    
        spike_out_source14,    spike_out_source15,    spike_out_source16,    
        spike_out_source17,    spike_out_source18, spike_out_source19
    );


    parameter  number_of_neurons=20;                            //number of neurons
    reg[11:0] neuron_addresses[0:number_of_neurons-1];          //initialize with neuron addresses
    reg[4:0] connection_pointer[0:number_of_neurons];         //point to connection starting point according to CSR
    reg[11:0] downstream_connections[0:(number_of_neurons*3)];  //support 5 connections per neuron
    reg al[0:number_of_neurons-1];                  //register the spikes
    reg[4:0] i;                                             //index for iteration
    reg[4:0] j;
    reg check=0;
    reg spike_register[0:number_of_neurons-1];
    
    //when neuron addresses are initilaized
    // always @(neuron_addresses_initialization) begin
    //     neuron_addresses[0] = neuron_addresses_initialization[119:108];
    //     neuron_addresses[1] = neuron_addresses_initialization[107:96];
    //     neuron_addresses[2] = neuron_addresses_initialization[95:84];
    //     neuron_addresses[3] = neuron_addresses_initialization[83:72];
    //     neuron_addresses[4] = neuron_addresses_initialization[71:60];
    //     neuron_addresses[5] = neuron_addresses_initialization[59:48];
    //     neuron_addresses[6] = neuron_addresses_initialization[47:36];
    //     neuron_addresses[7] = neuron_addresses_initialization[35:24];
    //     neuron_addresses[8] = neuron_addresses_initialization[23:12];
    //     neuron_addresses[9] = neuron_addresses_initialization[11:0];
    // end

    //when the connnection pointers come
    always @(connection_pointer_initialization) begin
        connection_pointer[0] = connection_pointer_initialization[54:50];
        connection_pointer[1] = connection_pointer_initialization[49:45];
        connection_pointer[2] = connection_pointer_initialization[44:40];
        connection_pointer[3] = connection_pointer_initialization[39:35];
        connection_pointer[4] = connection_pointer_initialization[34:30];
        connection_pointer[5] = connection_pointer_initialization[29:25];
        connection_pointer[6] = connection_pointer_initialization[24:20];
        connection_pointer[7] = connection_pointer_initialization[19:15];
        connection_pointer[8] = connection_pointer_initialization[14:10];
        connection_pointer[9] = connection_pointer_initialization[9:5];
        connection_pointer[10] = connection_pointer_initialization[4:0];
    end

    //initlize the connections
    always @(downstream_connections_initialization) begin
        downstream_connections[0] = downstream_connections_initialization[359:348];
        downstream_connections[1] = downstream_connections_initialization[347:336];
        downstream_connections[2] = downstream_connections_initialization[335:324];
        downstream_connections[3] = downstream_connections_initialization[323:312];
        downstream_connections[4] = downstream_connections_initialization[311:300];
        downstream_connections[5] = downstream_connections_initialization[299:288];
        downstream_connections[6] = downstream_connections_initialization[287:276];
        downstream_connections[7] = downstream_connections_initialization[275:264];
        downstream_connections[8] = downstream_connections_initialization[263:252];
        downstream_connections[9] = downstream_connections_initialization[251:240];
        downstream_connections[10] = downstream_connections_initialization[239:228];
        downstream_connections[11] = downstream_connections_initialization[227:216];
        downstream_connections[12] = downstream_connections_initialization[215:204];
        downstream_connections[13] = downstream_connections_initialization[203:192];
        downstream_connections[14] = downstream_connections_initialization[191:180];
        downstream_connections[15] = downstream_connections_initialization[179:168];
        downstream_connections[16] = downstream_connections_initialization[167:156];
        downstream_connections[17] = downstream_connections_initialization[155:144];
        downstream_connections[18] = downstream_connections_initialization[143:132];
        downstream_connections[19] = downstream_connections_initialization[131:120];
        downstream_connections[20] = downstream_connections_initialization[119:108];
        downstream_connections[21] = downstream_connections_initialization[107:96];
        downstream_connections[22] = downstream_connections_initialization[95:84];
        downstream_connections[23] = downstream_connections_initialization[83:72];
        downstream_connections[24] = downstream_connections_initialization[71:60];
        downstream_connections[25] = downstream_connections_initialization[59:48];
        downstream_connections[26] = downstream_connections_initialization[47:36];
        downstream_connections[27] = downstream_connections_initialization[35:24];
        downstream_connections[28] = downstream_connections_initialization[23:12];
        downstream_connections[29] = downstream_connections_initialization[11:0];
    end

    //send the spike whenever
    always @(clear, spike0, spike1, spike2, spike3, spike4, 
                spike5, spike6, spike7, spike8, spike9, 
                spike10, spike11, spike12, spike13, spike14, 
                spike15, spike16, spike17, spike18, spike19) begin
        #0.5
        spike_register[0] = spike0;
        spike_register[1] = spike1;
        spike_register[2] = spike2;
        spike_register[3] = spike3;
        spike_register[4] = spike4;
        spike_register[5] = spike5;
        spike_register[6] = spike6;
        spike_register[7] = spike7;
        spike_register[8] = spike8;
        spike_register[9] = spike9;
        spike_register[10] = spike10;
        spike_register[11] = spike11;
        spike_register[12] = spike12;
        spike_register[13] = spike13;
        spike_register[14] = spike14;
        spike_register[15] = spike15;
        spike_register[16] = spike16;
        spike_register[17] = spike17;
        spike_register[18] = spike18;
        spike_register[19] = spike19;

        // if(clear==1'b0) begin
        //     #0.5
        //     check = ~check;
        //     //if spiked send the source address to the relevant accumulator
        //     for(i=0; i<=9; i=i+1) begin
        //         if(spike_register[i]==1) begin
        //             for(j=connection_pointer[i]; j<connection_pointer[i+1]; j=j+1) begin
        //                 packet = #1 {neuron_addresses[i], downstream_connections[j]};
        //             end
        //             spike_register[i]=0;
        //         end
        //     end 
        // end


        if(clear==1'b0) begin
            #0.5
            check = ~check;

            case (spike_register[0])
                1'b1: begin
                    spike_out_source3 = #1 neuron_addresses[0];
                    spike_out_source5 = #1 neuron_addresses[0];
                    spike_out_source7 = #1 neuron_addresses[0];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[1])
                1'b1: begin
                    spike_out_source4 = #1 neuron_addresses[1];
                    spike_out_source6 = #1 neuron_addresses[1];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[2])
                1'b1: begin
                    spike_out_source4 = #1 neuron_addresses[2];
                    spike_out_source5 = #1 neuron_addresses[2];
                    spike_out_source6 = #1 neuron_addresses[2];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[3])
                1'b1: begin
                    spike_out_source8 = #1 neuron_addresses[3];
                    spike_out_source9 = #1 neuron_addresses[3];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[4])
                1'b1: begin
                    spike_out_source8 = #1 neuron_addresses[4];
                    spike_out_source9 = #1 neuron_addresses[4];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[5])
                1'b1: begin
                    spike_out_source8 = #1 neuron_addresses[5];
                    spike_out_source9 = #1 neuron_addresses[5];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[6])
                1'b1: begin
                    spike_out_source9 = #1 neuron_addresses[6];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[7])
                1'b1: begin
                    spike_out_source8 = #1 neuron_addresses[7];
                    spike_out_source9 = #1 neuron_addresses[7];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[8])
                1'b1: begin
                    spike_out_source13 = #1 neuron_addresses[8];
                    spike_out_source14 = #1 neuron_addresses[8];
                end 
                default: spike_out_source3 = 12'b111111111111;
            endcase

            case (spike_register[9])
                1'b1: begin
                    spike_out_source14 = #1 neuron_addresses[9];
                    spike_out_source15 = #1 neuron_addresses[9];
                    spike_out_source16 = #1 neuron_addresses[9];
                end 
                default: spike_out_source3 = 12'b111111111111;
            endcase
            case (spike_register[10])
                1'b1: begin
                    spike_out_source14 = #1 neuron_addresses[10];
                    spike_out_source15 = #1 neuron_addresses[10];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[11])
                1'b1: begin
                    spike_out_source14 = #1 neuron_addresses[11];
                    spike_out_source15 = #1 neuron_addresses[11];
                    spike_out_source16 = #1 neuron_addresses[11];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[12])
                1'b1: begin
                    spike_out_source13 = #1 neuron_addresses[12];
                    spike_out_source14 = #1 neuron_addresses[12];
                    spike_out_source15 = #1 neuron_addresses[12];
                    spike_out_source17 = #1 neuron_addresses[12];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[13])
                1'b1: begin
                    spike_out_source18 = #1 neuron_addresses[13];
                    spike_out_source19 = #1 neuron_addresses[13];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[14])
                1'b1: begin
                    spike_out_source18 = #1 neuron_addresses[14];
                    spike_out_source19 = #1 neuron_addresses[14];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[15])
                1'b1: begin
                    spike_out_source18 = #1 neuron_addresses[15];
                    spike_out_source19 = #1 neuron_addresses[15];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[16])
                1'b1: begin
                    spike_out_source18 = #1 neuron_addresses[16];
                    spike_out_source19 = #1 neuron_addresses[16];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            case (spike_register[17])
                1'b1: begin
                    spike_out_source18 = #1 neuron_addresses[17];
                    spike_out_source19 = #1 neuron_addresses[17];
                end 
                default: spike_out_source3 = #1 12'b111111111111;
            endcase

            // case (spike_register[18])
            // #1
            //     1'b1: begin
            //         spike_out_source13 = neuron_addresses[18];
            //         spike_out_source14 = neuron_addresses[18];
            //     end 
            //     default: spike_out_source3 = 12'b111111111111;
            // endcase

            // case (spike_register[19])
            // #1
            //     1'b1: begin
            //         spike_out_source14 = neuron_addresses[19];
            //         spike_out_source15 = neuron_addresses[19];
            //         spike_out_source16 = neuron_addresses[19];
            //     end 
            //     default: spike_out_source3 = 12'b111111111111;
            // endcase
        end
    end
    
    initial
    begin
        neuron_addresses[0] = 12'd0;
        neuron_addresses[1] = 12'd1;
        neuron_addresses[2] = 12'd2;
        neuron_addresses[3] = 12'd3;
        neuron_addresses[4] = 12'd4;
        neuron_addresses[5] = 12'd5;
        neuron_addresses[6] = 12'd6;
        neuron_addresses[7] = 12'd7;
        neuron_addresses[8] = 12'd8;
        neuron_addresses[9] = 12'd9;
        neuron_addresses[10] = 12'd10;
        neuron_addresses[11] = 12'd11;
        neuron_addresses[12] = 12'd12;
        neuron_addresses[13] = 12'd13;
        neuron_addresses[14] = 12'd14;
        neuron_addresses[15] = 12'd15;
        neuron_addresses[16] = 12'd16;
        neuron_addresses[17] = 12'd17;
        neuron_addresses[18] = 12'd18;
        neuron_addresses[19] = 12'd19;
        $monitor($time, " Spike Handle connection_pointer: %b\n", connection_pointer[0]);
    end

endmodule