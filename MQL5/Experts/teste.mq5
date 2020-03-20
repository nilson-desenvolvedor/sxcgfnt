//+------------------------------------------------------------------+
//|                                                        teste.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
//--- available signals
#include <Expert\Signal\SignalAC.mqh>
#include <Expert\Signal\SignalAMA.mqh>
#include <Expert\Signal\SignalMACD.mqh>
#include <Expert\Signal\SignalMA.mqh>
#include <Expert\Signal\SignalRSI.mqh>
#include <Expert\Signal\SignalStoch.mqh>
//--- available trailing
#include <Expert\Trailing\TrailingParabolicSAR.mqh>
//--- available money management
#include <Expert\Money\MoneyFixedRisk.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string             Expert_Title                 ="teste";     // Document name
ulong                    Expert_MagicNumber           =18637;       //
bool                     Expert_EveryTick             =false;       //
//--- inputs for main signal
input int                Signal_ThresholdOpen         =10;          // Signal threshold value to open [0...100]
input int                Signal_ThresholdClose        =10;          // Signal threshold value to close [0...100]
input double             Signal_PriceLevel            =0.0;         // Price level to execute a deal
input double             Signal_StopLevel             =50.0;        // Stop Loss level (in points)
input double             Signal_TakeLevel             =50.0;        // Take Profit level (in points)
input int                Signal_Expiration            =4;           // Expiration of pending orders (in bars)
input double             Signal_AC_Weight             =1.0;         // Accelerator Oscillator Weight [0...1.0]
input int                Signal_AMA_PeriodMA          =10;          // Adaptive Moving Average(10,...) Period of averaging
input int                Signal_AMA_PeriodFast        =2;           // Adaptive Moving Average(10,...) Period of fast EMA
input int                Signal_AMA_PeriodSlow        =30;          // Adaptive Moving Average(10,...) Period of slow EMA
input int                Signal_AMA_Shift             =0;           // Adaptive Moving Average(10,...) Time shift
input ENUM_APPLIED_PRICE Signal_AMA_Applied           =PRICE_CLOSE; // Adaptive Moving Average(10,...) Prices series
input double             Signal_AMA_Weight            =1.0;         // Adaptive Moving Average(10,...) Weight [0...1.0]
input int                Signal_MACD_PeriodFast       =12;          // MACD(12,24,9,PRICE_CLOSE) Period of fast EMA
input int                Signal_MACD_PeriodSlow       =24;          // MACD(12,24,9,PRICE_CLOSE) Period of slow EMA
input int                Signal_MACD_PeriodSignal     =9;           // MACD(12,24,9,PRICE_CLOSE) Period of averaging of difference
input ENUM_APPLIED_PRICE Signal_MACD_Applied          =PRICE_CLOSE; // MACD(12,24,9,PRICE_CLOSE) Prices series
input double             Signal_MACD_Weight           =1.0;         // MACD(12,24,9,PRICE_CLOSE) Weight [0...1.0]
input int                Signal_0_MA_PeriodMA         =12;          // Moving Average(12,0,...) Period of averaging
input int                Signal_0_MA_Shift            =0;           // Moving Average(12,0,...) Time shift
input ENUM_MA_METHOD     Signal_0_MA_Method           =MODE_SMA;    // Moving Average(12,0,...) Method of averaging
input ENUM_APPLIED_PRICE Signal_0_MA_Applied          =PRICE_CLOSE; // Moving Average(12,0,...) Prices series
input double             Signal_0_MA_Weight           =1.0;         // Moving Average(12,0,...) Weight [0...1.0]
input int                Signal_RSI_PeriodRSI         =8;           // Relative Strength Index(8,...) Period of calculation
input ENUM_APPLIED_PRICE Signal_RSI_Applied           =PRICE_CLOSE; // Relative Strength Index(8,...) Prices series
input double             Signal_RSI_Weight            =1.0;         // Relative Strength Index(8,...) Weight [0...1.0]
input int                Signal_Stoch_PeriodK         =8;           // Stochastic(8,3,3,...) K-period
input int                Signal_Stoch_PeriodD         =3;           // Stochastic(8,3,3,...) D-period
input int                Signal_Stoch_PeriodSlow      =3;           // Stochastic(8,3,3,...) Period of slowing
input ENUM_STO_PRICE     Signal_Stoch_Applied         =STO_LOWHIGH; // Stochastic(8,3,3,...) Prices to apply to
input double             Signal_Stoch_Weight          =1.0;         // Stochastic(8,3,3,...) Weight [0...1.0]
input int                Signal_1_MA_PeriodMA         =12;          // Moving Average(12,0,...) M15 Period of averaging
input int                Signal_1_MA_Shift            =0;           // Moving Average(12,0,...) M15 Time shift
input ENUM_MA_METHOD     Signal_1_MA_Method           =MODE_SMA;    // Moving Average(12,0,...) M15 Method of averaging
input ENUM_APPLIED_PRICE Signal_1_MA_Applied          =PRICE_CLOSE; // Moving Average(12,0,...) M15 Prices series
input double             Signal_1_MA_Weight           =1.0;         // Moving Average(12,0,...) M15 Weight [0...1.0]
//--- inputs for trailing
input double             Trailing_ParabolicSAR_Step   =0.02;        // Speed increment
input double             Trailing_ParabolicSAR_Maximum=0.2;         // Maximum rate
//--- inputs for money
input double             Money_FixRisk_Percent        =10.0;        // Risk percentage
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Creating signal
   CExpertSignal *signal=new CExpertSignal;
   if(signal==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//---
   ExtExpert.InitSignal(signal);
   signal.ThresholdOpen(Signal_ThresholdOpen);
   signal.ThresholdClose(Signal_ThresholdClose);
   signal.PriceLevel(Signal_PriceLevel);
   signal.StopLevel(Signal_StopLevel);
   signal.TakeLevel(Signal_TakeLevel);
   signal.Expiration(Signal_Expiration);
//--- Creating filter CSignalAC
   CSignalAC *filter0=new CSignalAC;
   if(filter0==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter0");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter0);
//--- Set filter parameters
   filter0.Weight(Signal_AC_Weight);
//--- Creating filter CSignalAMA
   CSignalAMA *filter1=new CSignalAMA;
   if(filter1==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter1");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter1);
//--- Set filter parameters
   filter1.PeriodMA(Signal_AMA_PeriodMA);
   filter1.PeriodFast(Signal_AMA_PeriodFast);
   filter1.PeriodSlow(Signal_AMA_PeriodSlow);
   filter1.Shift(Signal_AMA_Shift);
   filter1.Applied(Signal_AMA_Applied);
   filter1.Weight(Signal_AMA_Weight);
//--- Creating filter CSignalMACD
   CSignalMACD *filter2=new CSignalMACD;
   if(filter2==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter2");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter2);
//--- Set filter parameters
   filter2.PeriodFast(Signal_MACD_PeriodFast);
   filter2.PeriodSlow(Signal_MACD_PeriodSlow);
   filter2.PeriodSignal(Signal_MACD_PeriodSignal);
   filter2.Applied(Signal_MACD_Applied);
   filter2.Weight(Signal_MACD_Weight);
//--- Creating filter CSignalMA
   CSignalMA *filter3=new CSignalMA;
   if(filter3==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter3");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter3);
//--- Set filter parameters
   filter3.PeriodMA(Signal_0_MA_PeriodMA);
   filter3.Shift(Signal_0_MA_Shift);
   filter3.Method(Signal_0_MA_Method);
   filter3.Applied(Signal_0_MA_Applied);
   filter3.Weight(Signal_0_MA_Weight);
//--- Creating filter CSignalRSI
   CSignalRSI *filter4=new CSignalRSI;
   if(filter4==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter4");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter4);
//--- Set filter parameters
   filter4.PeriodRSI(Signal_RSI_PeriodRSI);
   filter4.Applied(Signal_RSI_Applied);
   filter4.Weight(Signal_RSI_Weight);
//--- Creating filter CSignalStoch
   CSignalStoch *filter5=new CSignalStoch;
   if(filter5==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter5");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter5);
//--- Set filter parameters
   filter5.PeriodK(Signal_Stoch_PeriodK);
   filter5.PeriodD(Signal_Stoch_PeriodD);
   filter5.PeriodSlow(Signal_Stoch_PeriodSlow);
   filter5.Applied(Signal_Stoch_Applied);
   filter5.Weight(Signal_Stoch_Weight);
//--- Creating filter CSignalMA
   CSignalMA *filter6=new CSignalMA;
   if(filter6==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter6");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter6);
//--- Set filter parameters
   filter6.Period(PERIOD_M15);
   filter6.PeriodMA(Signal_1_MA_PeriodMA);
   filter6.Shift(Signal_1_MA_Shift);
   filter6.Method(Signal_1_MA_Method);
   filter6.Applied(Signal_1_MA_Applied);
   filter6.Weight(Signal_1_MA_Weight);
//--- Creation of trailing object
   CTrailingPSAR *trailing=new CTrailingPSAR;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set trailing parameters
   trailing.Step(Trailing_ParabolicSAR_Step);
   trailing.Maximum(Trailing_ParabolicSAR_Maximum);
//--- Creation of money object
   CMoneyFixedRisk *money=new CMoneyFixedRisk;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set money parameters
   money.Percent(Money_FixRisk_Percent);
//--- Check all trading objects parameters
   if(!ExtExpert.ValidationSettings())
     {
      //--- failed
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- ok
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExtExpert.Deinit();
  }
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExtExpert.OnTick();
  }
//+------------------------------------------------------------------+
//| "Trade" event handler function                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//| "Timer" event handler function                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
