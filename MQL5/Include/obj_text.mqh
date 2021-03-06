//--- descrição
#property description "Script cria objeto gráfico de \"Texto\"."
//--- janela de exibição dos parâmetros de entrada durante inicialização do script
#property script_show_inputs
//--- entrada de parâmetros do script
input string            InpFont="Arial";         // Fonte
input int               InpFontSize=10;          // Tamanho da fonte
//input color             InpColor=clrRed;         // Cor
input double            InpAngle=90.0;           // Ângulo de inclinação em graus
input ENUM_ANCHOR_POINT InpAnchor=ANCHOR_LEFT;   // Tipo de ancoragem
//input bool              InpBack=false;           // Objeto de fundo
//input bool              InpSelection=false;      // Destaque para mover
//input bool              InpHidden=true;          // Ocultar na lista de objetos
//input long              InpZOrder=0;             // Prioridade para clique do mouse
//+------------------------------------------------------------------+
//| Criando objeto Texto                                             |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // ID do gráfico
                const string            name="Text",              // nome do objeto
                const int               sub_window=0,             // índice da sub-janela
                datetime                time=0,                   // ponto de ancoragem do tempo
                double                  price=0,                  // ponto de ancoragem do preço
                const string            text="Text",              // o próprio texto
                const string            font="Arial",             // fonte
                const int               font_size=10,             // tamanho da fonte
                const color             clr=clrRed,               // cor
                const double            angle=0.0,                // inclinação do texto
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // tipo de ancoragem
                const bool              back=false,               // no fundo
                const bool              selection=false,          // destaque para mover
                const bool              hidden=true,              // ocultar na lista de objetos
                const long              z_order=0)                // prioridade para clicar no mouse
  {
  
  
//se o texto ja existir executar a função move
   if (!ObjectFind(0, name)){
      TextMove(chart_ID, name, time, price);
      return true;
      
      Print("criando", name);
   
   
   
   } 
  
  
//--- definir as coordenadas de pontos de ancoragem, se eles não estão definidos
   ChangeTextEmptyPoint(time,price);
//--- redefine o valor de erro
   ResetLastError();
//--- criar objeto Texto
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": falha ao criar objeto \"Texto\"! Código de erro = ",GetLastError());
      return(false);
     }
//--- definir o texto
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- definir o texto fonte
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- definir tamanho da fonte
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- definir o ângulo de inclinação do texto
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- tipo de definição de ancoragem
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- definir cor
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- exibir em primeiro plano (false) ou fundo (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- habilitar (true) ou desabilitar (false) o modo de mover o objeto com o mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- ocultar (true) ou exibir (false) o nome do objeto gráfico na lista de objeto 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- definir a prioridade para receber o evento com um clique do mouse no gráfico
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Mover ponto de ancoragem                                         |
//+------------------------------------------------------------------+
bool TextMove(const long   chart_ID=0,  // ID do gráfico
              const string name="Text", // nome do objeto
              datetime     time=0,      // coordenada do ponto de ancoragem do tempo
              double       price=0)     // coordenada do ponto de ancoragem do preço
  {
//--- se a posição do ponto não está definida, mover para a barra atual tendo o preço Bid
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- redefine o valor de erro
   ResetLastError();
//--- mover o ponto de ancoragem
   if(!ObjectMove(chart_ID,name,0,time,price))
     {
      Print(__FUNCTION__,
            ": falha ao mover o ponto de ancoragem! Código de erro = ",GetLastError());
      return(false);
     }
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Alterar o texto do objeto                                        |
//+------------------------------------------------------------------+
bool TextChange(const long   chart_ID=0,  // ID do Gráfico
                const string name="Text", // nome do objeto
                const string text="Text") // texto
  {
//--- redefine o valor de erro
   ResetLastError();
//--- alterar texto do objeto
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": falha ao alterar texto! Código de erro = ",GetLastError());
      return(false);
     }
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Excluir objeto Texto                                             |
//+------------------------------------------------------------------+
bool TextDelete(const long   chart_ID=0,  // Id do Gráfico
                const string name="Text") // nome do objeto
  {
//--- redefine o valor de erro
   ResetLastError();
//--- excluir o objeto
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": falha ao excluir o objeto \"Texto\"! Código de erro = ",GetLastError());
      return(false);
     }
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Verificar valores de ponto de ancoragem e definir valores padrão |
//| para aqueles vazios                                              |
//+------------------------------------------------------------------+
void ChangeTextEmptyPoint(datetime &time,double &price)
  {
//--- se o tempo do ponto não está definido, será na barra atual
   if(!time)
      time=TimeCurrent();
//--- se o preço do ponto não está definido, ele terá valor Bid
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
