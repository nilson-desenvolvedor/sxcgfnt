//+------------------------------------------------------------------+
//|                                                       ZigZag.mq5 |
//|                   Copyright 2009-2019, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009-2017, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   1
//---- plot ZigZag
#property indicator_label1  "ZigZag"
#property indicator_type1   DRAW_SECTION
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int      InpDepth    =12;
input int      InpDeviation=5;
input int      InpBackstep =3;
//--- indicator buffers
double         ZigZagBuffer[];      // main buffer
double         HighMapBuffer[];     // ZigZag high extremes (peaks)
double         LowMapBuffer[];      // ZigZag low extremes (bottoms)
int            ExtRecalc=3;         // number of last extremes for recalculation
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ZigZagBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,HighMapBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(2,LowMapBuffer,INDICATOR_CALCULATIONS);

//--- set short name and digits
   PlotIndexSetString(0,PLOT_LABEL,"ZigZag("+(string)InpDepth+","+(string)InpDeviation+","+(string)InpBackstep+")");
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//--- set an empty value
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
//---
   return(0);
  }
//+------------------------------------------------------------------+
//|  Search for the index of the highest bar                         |
//+------------------------------------------------------------------+
int Highest(const double &array[],int depth,int start)
  {
//--- validation of the start index
   if(start<0)
     {
      Print("Invalid parameter in the function Highest, start =",start);
      return 0;
     }
   int size=ArraySize(array);
//--- reduce depth to the available data if needed
   if(start-depth<0)
      depth=start;
   double max=array[start];
//--- start searching
   int index=start;
   for(int i=start; i>start-depth; i--)
     {
      if(array[i]>max)
        {
         index=i;
         max=array[i];
        }
     }
//--- return index of the highest bar
   return(index);
  }
//+------------------------------------------------------------------+
//|  Search for the index of the lowest bar                          |
//+------------------------------------------------------------------+
int Lowest(const double &array[],int depth,int start)
  {
//--- validation of the start index
   if(start<0)
     {
      Print("Invalid parameter in the function iLowest, start =",start);
      return 0;
     }
   int size=ArraySize(array);
//--- reduce depth to the available data if needed
   if(start-depth<0)
      depth=start;
   double min=array[start];
//--- start searching
   int index=start;
   for(int i=start; i>start-depth; i--)
     {
      if(array[i]<min)
        {
         index=i;
         min=array[i];
        }
     }
//--- return index of the lowest bar
   return(index);
  }
//--- auxiliary enumeration
enum EnSearchMode
  {
   Peak=1,    // searching for the next ZigZag peak
   Bottom=-1  // searching for the next ZigZag bottom
  };
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int i=0;
   int limit=0,extreme_counter=0,extreme_search=0;
   int shift=0,back=0,last_high_pos=0,last_low_pos=0;
   double val=0,res=0;
   double curlow=0,curhigh=0,last_high=0,last_low=0;
//--- initializing
   if(prev_calculated==0)
     {
      ArrayInitialize(ZigZagBuffer,0.0);
      ArrayInitialize(HighMapBuffer,0.0);
      ArrayInitialize(LowMapBuffer,0.0);
     }
//---
   if(rates_total<100)
      return(0);
//--- set start position for calculations
   if(prev_calculated==0)
      limit=InpDepth;

//--- ZigZag was already calculated before
   if(prev_calculated>0)
     {
      i=rates_total-1;
      //--- searching for the third extremum from the last uncompleted bar
      while(extreme_counter<ExtRecalc && i>rates_total-100)
        {
         res=ZigZagBuffer[i];
         if(res!=0)
            extreme_counter++;
         i--;
        }
      i++;
      limit=i;

      //--- what type of exremum we search for
      if(LowMapBuffer[i]!=0)
        {
         curlow=LowMapBuffer[i];
         extreme_search=Peak;
        }
      else
        {
         curhigh=HighMapBuffer[i];
         extreme_search=Bottom;
        }
      //--- clear indicator values
      for(i=limit+1; i<rates_total && !IsStopped(); i++)
        {
         ZigZagBuffer[i] =0.0;
         LowMapBuffer[i] =0.0;
         HighMapBuffer[i]=0.0;
        }
     }

//--- searching for high and low extremes
   for(shift=limit; shift<rates_total && !IsStopped(); shift++)
     {
      //--- low
      val=low[Lowest(low,InpDepth,shift)];
      if(val==last_low)
         val=0.0;
      else
        {
         last_low=val;
         if((low[shift]-val)>InpDeviation*_Point)
            val=0.0;
         else
           {
            for(back=1; back<=InpBackstep; back++)
              {
               res=LowMapBuffer[shift-back];
               if((res!=0) && (res>val))
                  LowMapBuffer[shift-back]=0.0;
              }
           }
        }
      if(low[shift]==val)
         LowMapBuffer[shift]=val;
      else
         LowMapBuffer[shift]=0.0;
      //--- high
      val=high[Highest(high,InpDepth,shift)];
      if(val==last_high)
         val=0.0;
      else
        {
         last_high=val;
         if((val-high[shift])>InpDeviation*_Point)
            val=0.0;
         else
           {
            for(back=1; back<=InpBackstep; back++)
              {
               res=HighMapBuffer[shift-back];
               if((res!=0) && (res<val))
                  HighMapBuffer[shift-back]=0.0;
              }
           }
        }
      if(high[shift]==val)
         HighMapBuffer[shift]=val;
      else
         HighMapBuffer[shift]=0.0;
     }

//--- set last values
   if(extreme_search==0) // undefined values
     {
      last_low=0;
      last_high=0;
     }
   else
     {
      last_low=curlow;
      last_high=curhigh;
     }

//--- final selection of extreme points for ZigZag
   for(shift=limit; shift<rates_total && !IsStopped(); shift++)
     {
      res=0.0;
      switch(extreme_search)
        {
         case 0: // search for an extremum
            if(last_low==0 && last_high==0)
              {
               if(HighMapBuffer[shift]!=0)
                 {
                  last_high=high[shift];
                  last_high_pos=shift;
                  extreme_search=Bottom;
                  ZigZagBuffer[shift]=last_high;
                  res=1;
                 }
               if(LowMapBuffer[shift]!=0)
                 {
                  last_low=low[shift];
                  last_low_pos=shift;
                  extreme_search=Peak;
                  ZigZagBuffer[shift]=last_low;
                  res=1;
                 }
              }
            break;
         case Peak: // search for peak
            if(LowMapBuffer[shift]!=0.0 && LowMapBuffer[shift]<last_low && HighMapBuffer[shift]==0.0)
              {
               ZigZagBuffer[last_low_pos]=0.0;
               last_low_pos=shift;
               last_low=LowMapBuffer[shift];
               ZigZagBuffer[shift]=last_low;
               res=1;
              }
            if(HighMapBuffer[shift]!=0.0 && LowMapBuffer[shift]==0.0)
              {
               last_high=HighMapBuffer[shift];
               last_high_pos=shift;
               ZigZagBuffer[shift]=last_high;
               extreme_search=Bottom;
               res=1;
              }
            break;
         case Bottom: // search for bottom
            if(HighMapBuffer[shift]!=0.0 && HighMapBuffer[shift]>last_high && LowMapBuffer[shift]==0.0)
              {
               ZigZagBuffer[last_high_pos]=0.0;
               last_high_pos=shift;
               last_high=HighMapBuffer[shift];
               ZigZagBuffer[shift]=last_high;
              }
            if(LowMapBuffer[shift]!=0.0 && HighMapBuffer[shift]==0.0)
              {
               last_low=LowMapBuffer[shift];
               last_low_pos=shift;
               ZigZagBuffer[shift]=last_low;
               extreme_search=Peak;
              }
            break;
         default:
            return(rates_total);
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
