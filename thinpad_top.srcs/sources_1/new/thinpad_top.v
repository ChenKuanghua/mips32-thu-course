`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz æ—¶é’Ÿè¾“å…¥
    input wire clk_11M0592,       //11.0592MHz æ—¶é’Ÿè¾“å…¥

    input wire clock_btn,         //BTN5æ‰‹åŠ¨æ—¶é’ŸæŒ‰é’®å¼?å…³ï¼Œå¸¦æ¶ˆæŠ–ç”µè·¯ï¼ŒæŒ‰ä¸‹æ—¶ä¸º1
    input wire reset_btn,         //BTN6æ‰‹åŠ¨å¤ä½æŒ‰é’®å¼?å…³ï¼Œå¸¦æ¶ˆæŠ–ç”µè·¯ï¼ŒæŒ‰ä¸‹æ—¶ä¸º1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4ï¼ŒæŒ‰é’®å¼€å…³ï¼ŒæŒ‰ä¸‹æ—¶ä¸º1
    input  wire[31:0] dip_sw,     //32ä½æ‹¨ç å¼€å…³ï¼Œæ‹¨åˆ°â€œONâ€æ—¶ä¸?1
    output wire[15:0] leds,       //16ä½LEDï¼Œè¾“å‡ºæ—¶1ç‚¹äº®
    output wire[7:0]  dpy0,       //æ•°ç ç®¡ä½Žä½ä¿¡å·ï¼ŒåŒ…æ‹¬å°æ•°ç‚¹ï¼Œè¾“å‡º1ç‚¹äº®
    output wire[7:0]  dpy1,       //æ•°ç ç®¡é«˜ä½ä¿¡å·ï¼ŒåŒ…æ‹¬å°æ•°ç‚¹ï¼Œè¾“å‡º1ç‚¹äº®

    //CPLDä¸²å£æŽ§åˆ¶å™¨ä¿¡å?
    output wire uart_rdn,         //è¯»ä¸²å£ä¿¡å·ï¼Œä½Žæœ‰æ•?
    output wire uart_wrn,         //å†™ä¸²å£ä¿¡å·ï¼Œä½Žæœ‰æ•?
    input wire uart_dataready,    //ä¸²å£æ•°æ®å‡†å¤‡å¥?
    input wire uart_tbre,         //å‘é?æ•°æ®æ ‡å¿?
    input wire uart_tsre,         //æ•°æ®å‘é?å®Œæ¯•æ ‡å¿?

    //BaseRAMä¿¡å·
    inout wire[31:0] base_ram_data,  //BaseRAMæ•°æ®ï¼Œä½Ž8ä½ä¸ŽCPLDä¸²å£æŽ§åˆ¶å™¨å…±äº?
    output wire[19:0] base_ram_addr, //BaseRAMåœ°å€
    output wire[3:0] base_ram_be_n,  //BaseRAMå­—èŠ‚ä½¿èƒ½ï¼Œä½Žæœ‰æ•ˆã€‚å¦‚æžœä¸ä½¿ç”¨å­—èŠ‚ä½¿èƒ½ï¼Œè¯·ä¿æŒä¸?0
    output wire base_ram_ce_n,       //BaseRAMç‰‡é?‰ï¼Œä½Žæœ‰æ•?
    output wire base_ram_oe_n,       //BaseRAMè¯»ä½¿èƒ½ï¼Œä½Žæœ‰æ•?
    output wire base_ram_we_n,       //BaseRAMå†™ä½¿èƒ½ï¼Œä½Žæœ‰æ•?

    //ExtRAMä¿¡å·
    inout wire[31:0] ext_ram_data,  //ExtRAMæ•°æ®
    output wire[19:0] ext_ram_addr, //ExtRAMåœ°å€
    output wire[3:0] ext_ram_be_n,  //ExtRAMå­—èŠ‚ä½¿èƒ½ï¼Œä½Žæœ‰æ•ˆã€‚å¦‚æžœä¸ä½¿ç”¨å­—èŠ‚ä½¿èƒ½ï¼Œè¯·ä¿æŒä¸?0
    output wire ext_ram_ce_n,       //ExtRAMç‰‡é?‰ï¼Œä½Žæœ‰æ•?
    output wire ext_ram_oe_n,       //ExtRAMè¯»ä½¿èƒ½ï¼Œä½Žæœ‰æ•?
    output wire ext_ram_we_n,       //ExtRAMå†™ä½¿èƒ½ï¼Œä½Žæœ‰æ•?

    //ç›´è¿žä¸²å£ä¿¡å·
    output wire txd,  //ç›´è¿žä¸²å£å‘é?ç«¯
    input  wire rxd,  //ç›´è¿žä¸²å£æŽ¥æ”¶ç«?

    //Flashå­˜å‚¨å™¨ä¿¡å·ï¼Œå‚è?? JS28F640 èŠ¯ç‰‡æ‰‹å†Œ
    output wire [22:0]flash_a,      //Flashåœ°å€ï¼Œa0ä»…åœ¨8bitæ¨¡å¼æœ‰æ•ˆï¼?16bitæ¨¡å¼æ— æ„ä¹?
    inout  wire [15:0]flash_d,      //Flashæ•°æ®
    output wire flash_rp_n,         //Flashå¤ä½ä¿¡å·ï¼Œä½Žæœ‰æ•ˆ
    output wire flash_vpen,         //Flashå†™ä¿æŠ¤ä¿¡å·ï¼Œä½Žç”µå¹³æ—¶ä¸èƒ½æ“¦é™¤ã€çƒ§å†?
    output wire flash_ce_n,         //Flashç‰‡é?‰ä¿¡å·ï¼Œä½Žæœ‰æ•?
    output wire flash_oe_n,         //Flashè¯»ä½¿èƒ½ä¿¡å·ï¼Œä½Žæœ‰æ•?
    output wire flash_we_n,         //Flashå†™ä½¿èƒ½ä¿¡å·ï¼Œä½Žæœ‰æ•?
    output wire flash_byte_n,       //Flash 8bitæ¨¡å¼é€‰æ‹©ï¼Œä½Žæœ‰æ•ˆã€‚åœ¨ä½¿ç”¨flashçš?16ä½æ¨¡å¼æ—¶è¯·è®¾ä¸?1

    //USB æŽ§åˆ¶å™¨ä¿¡å·ï¼Œå‚è?? SL811 èŠ¯ç‰‡æ‰‹å†Œ
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USBæ•°æ®çº¿ä¸Žç½‘ç»œæŽ§åˆ¶å™¨çš„dm9k_sd[7:0]å…±äº«
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //ç½‘ç»œæŽ§åˆ¶å™¨ä¿¡å·ï¼Œå‚è?? DM9000A èŠ¯ç‰‡æ‰‹å†Œ
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //å›¾åƒè¾“å‡ºä¿¡å·
    output wire[2:0] video_red,    //çº¢è‰²åƒç´ ï¼?3ä½?
    output wire[2:0] video_green,  //ç»¿è‰²åƒç´ ï¼?3ä½?
    output wire[1:0] video_blue,   //è“è‰²åƒç´ ï¼?2ä½?
    output wire video_hsync,       //è¡ŒåŒæ­¥ï¼ˆæ°´å¹³åŒæ­¥ï¼‰ä¿¡å?
    output wire video_vsync,       //åœºåŒæ­¥ï¼ˆåž‚ç›´åŒæ­¥ï¼‰ä¿¡å?
    output wire video_clk,         //åƒç´ æ—¶é’Ÿè¾“å‡º
    output wire video_de           //è¡Œæ•°æ®æœ‰æ•ˆä¿¡å·ï¼Œç”¨äºŽåŒºåˆ†æ¶ˆéšåŒ?
);

/* =========== Demo code begin =========== */

// PLLåˆ†é¢‘ç¤ºä¾‹
wire locked, clk_10M, clk_20M;
pll_example clock_gen 
 (
  // Clock out ports
  .clk_out1(clk_10M), // æ—¶é’Ÿè¾“å‡º1ï¼Œé¢‘çŽ‡åœ¨IPé…ç½®ç•Œé¢ä¸­è®¾ç½?
  .clk_out2(clk_20M), // æ—¶é’Ÿè¾“å‡º2ï¼Œé¢‘çŽ‡åœ¨IPé…ç½®ç•Œé¢ä¸­è®¾ç½?
  // Status and control signals
  .reset(reset_btn), // PLLå¤ä½è¾“å…¥
  .locked(locked), // é”å®šè¾“å‡ºï¼?"1"è¡¨ç¤ºæ—¶é’Ÿç¨³å®šï¼Œå¯ä½œä¸ºåŽçº§ç”µè·¯å¤ä½
 // Clock in ports
  .clk_in1(clk_50M) // å¤–éƒ¨æ—¶é’Ÿè¾“å…¥
 );

reg reset_of_clk10M;
// å¼‚æ­¥å¤ä½ï¼ŒåŒæ­¥é‡Šæ”?
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end

always@(posedge clk_10M or posedge reset_of_clk10M) begin
    if(reset_of_clk10M)begin
        // Your Code
    end
    else begin
        // Your Code
    end
end

// ä¸ä½¿ç”¨å†…å­˜ã?ä¸²å£æ—¶ï¼Œç¦ç”¨å…¶ä½¿èƒ½ä¿¡å·

assign ext_ram_ce_n = 1'b1;
assign ext_ram_oe_n = 1'b1;
assign ext_ram_we_n = 1'b1;

// æ•°ç ç®¡è¿žæŽ¥å…³ç³»ç¤ºæ„å›¾ï¼Œdpy1åŒç†
// p=dpy0[0] // ---a---
// c=dpy0[1] // |     |
// d=dpy0[2] // f     b
// e=dpy0[3] // |     |
// b=dpy0[4] // ---g---
// a=dpy0[5] // |     |
// f=dpy0[6] // e     c
// g=dpy0[7] // |     |
//           // ---d---  p

// 7æ®µæ•°ç ç®¡è¯‘ç å™¨æ¼”ç¤ºï¼Œå°†numberç”?16è¿›åˆ¶æ˜¾ç¤ºåœ¨æ•°ç ç®¡ä¸Šé¢
reg[7:0] number;
SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0æ˜¯ä½Žä½æ•°ç ç®¡
SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1æ˜¯é«˜ä½æ•°ç ç


//ç›´è¿žä¸²å£æŽ¥æ”¶å‘é?æ¼”ç¤ºï¼Œä»Žç›´è¿žä¸²å£æ”¶åˆ°çš„æ•°æ®å†å‘é€å‡ºåŽ?
wire [7:0] ext_uart_rx;
reg  [7:0] ext_uart_buffer, ext_uart_tx;
wire ext_uart_ready, ext_uart_busy;
reg ext_uart_start, ext_uart_avai;

async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //æŽ¥æ”¶æ¨¡å—ï¼?9600æ— æ£€éªŒä½
    ext_uart_r(
        .clk(clk_50M),                       //å¤–éƒ¨æ—¶é’Ÿä¿¡å·
        .RxD(rxd),                           //å¤–éƒ¨ä¸²è¡Œä¿¡å·è¾“å…¥
        .RxD_data_ready(ext_uart_ready),  //æ•°æ®æŽ¥æ”¶åˆ°æ ‡å¿?
        .RxD_clear(ext_uart_ready),       //æ¸…é™¤æŽ¥æ”¶æ ‡å¿—
        .RxD_data(ext_uart_rx)             //æŽ¥æ”¶åˆ°çš„ä¸?å­—èŠ‚æ•°æ®
    );
    
always @(posedge clk_50M) begin //æŽ¥æ”¶åˆ°ç¼“å†²åŒºext_uart_buffer
    if(ext_uart_ready)begin
        ext_uart_buffer <= ext_uart_rx;
        ext_uart_avai <= 1;
    end else if(!ext_uart_busy && ext_uart_avai)begin 
        ext_uart_avai <= 0;
    end
end
always @(posedge clk_50M) begin //å°†ç¼“å†²åŒºext_uart_bufferå‘é?å‡ºåŽ?
    if(!ext_uart_busy && ext_uart_avai)begin 
        ext_uart_tx <= ext_uart_buffer;
        ext_uart_start <= 1;
    end else begin 
        ext_uart_start <= 0;
    end
end

async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //å‘é?æ¨¡å—ï¼Œ9600æ— æ£€éªŒä½
    ext_uart_t(
        .clk(clk_50M),                  //å¤–éƒ¨æ—¶é’Ÿä¿¡å·
        .TxD(txd),                      //ä¸²è¡Œä¿¡å·è¾“å‡º
        .TxD_busy(ext_uart_busy),       //å‘é?å™¨å¿™çŠ¶æ€æŒ‡ç¤?
        .TxD_start(ext_uart_start),    //å¼?å§‹å‘é€ä¿¡å?
        .TxD_data(ext_uart_tx)        //å¾…å‘é€çš„æ•°æ®
    );

//å›¾åƒè¾“å‡ºæ¼”ç¤ºï¼Œåˆ†è¾¨çŽ‡800x600@75Hzï¼Œåƒç´ æ—¶é’Ÿä¸º50MHz
wire [11:0] hdata;
assign video_red = hdata < 266 ? 3'b111 : 0; //çº¢è‰²ç«–æ¡
assign video_green = hdata < 532 && hdata >= 266 ? 3'b111 : 0; //ç»¿è‰²ç«–æ¡
assign video_blue = hdata >= 532 ? 2'b11 : 0; //è“è‰²ç«–æ¡
assign video_clk = clk_50M;
vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
    .clk(clk_50M), 
    .hdata(hdata), //æ¨ªåæ ?
    .vdata(),      //çºµåæ ?
    .hsync(video_hsync),
    .vsync(video_vsync),
    .data_enable(video_de)
);
/* =========== Demo code end =========== */

endmodule
