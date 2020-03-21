//+------------------------------------------------------------------+
//|                                                   auxiliares.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>


#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


double razao_aura = (1+MathSqrt(5))/2;

double conversao(void){
   if (StringSubstr(_Symbol, 0, 3)=="WIN"){
      return 0.2;
   }
   else if (StringSubstr(_Symbol, 0, 3)=="WDO"){
      return 10;
   }
   
   return 0;
}

double v2pra1tp(void){
   if (StringSubstr(_Symbol, 0, 3)=="WIN"){
      return 200;
   }
   else if (StringSubstr(_Symbol, 0, 3)=="WDO"){
      return 6;
   }
   
   return 0;

}


double v2pra1sl(void){
   if (StringSubstr(_Symbol, 0, 3)=="WIN"){
      return 100;
   }
   else if (StringSubstr(_Symbol, 0, 3)=="WDO"){
      return 3;
   }
   
   return 0;

}

double acerta_preco(double x){

   CSymbolInfo symbol_info;
   symbol_info.Name(_Symbol); 
   double ts = symbol_info.TickSize(); 

   return ts * MathRound(x/ts);


}