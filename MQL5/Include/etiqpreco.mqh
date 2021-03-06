#property description "Script cria a Etiqueta Preço Lado Esquerdo no gráfico."
#property description "Coordenadas do ponto de ancoragem é definido em"
#property description "porcentagem do tamanho da janela de gráfico."
//--- janela de exibição dos parâmetros de entrada durante inicialização do script
#property script_show_inputs
//--- entrada de parâmetros do script

//+------------------------------------------------------------------+
//| Criar Etiqueta Preço Lado Esquerdo                              |
//+------------------------------------------------------------------+
bool ArrowLeftPriceCreate(const long            chart_ID=0,        // ID do gráfico
                          const string          name="LeftPrice",  // nome da etiqueta de preço
                          const int             sub_window=0,      // índice da sub-janela
                          datetime              time=0,            // ponto de ancoragem do tempo
                          double                price=0,           // ponto de ancoragem do preço
                          const color           clr=clrRed,        // cor da etiqueta de preço
                          const ENUM_LINE_STYLE style=STYLE_SOLID, // estilo de linha da borda
                          const int             width=1,           // tamanho da etiqueta de preço
                          const bool            back=false,        // no fundo
                          const bool            selection=true,    // destaque para mover
                          const bool            hidden=true,       // ocultar na lista de objetos
                          const long            z_order=0)         // prioridade para clicar no mouse
  {
  if (ObjectFind(chart_ID, name)>=0){ArrowLeftPriceMove(chart_ID, name, time, price);}
//--- definir as coordenadas de pontos de ancoragem, se eles não estão definidos
   ChangeArrowEmptyPointx(time,price);
//--- redefine o valor de erro
   ResetLastError();
//--- criar uma etiqueta de preço
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_LEFT_PRICE,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": falha ao criar a etiqueta preço lado esquerdo! Código de erro = ",GetLastError());
      return(false);
     }
//--- definir a cor da etiqueta
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- definir o estilo da linha da borda
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- definir o tamanho da etiqueta
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- exibir em primeiro plano (false) ou fundo (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- Habilitar (true) ou desabilitar (false) o modo de movimento da etiqueta pelo mouse
//--- ao criar um objeto gráfico usando a função ObjectCreate, o objeto não pode ser
//--- destacado e movimentado por padrão. Dentro deste método, o parâmetro de seleção
//--- é verdade por padrão, tornando possível destacar e mover o objeto
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
bool ArrowLeftPriceMove(const long   chart_ID=0,       // ID do gráfico
                        const string name="LeftPrice", // nome da etiqueta
                        datetime     time=0,           // coordenada do ponto de ancoragem de tempo
                        double       price=0)          // coordenada do ponto de ancoragem de tempo
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
//| Excluir a etiqueta preço lado esquerdo do gráfico                |
//+------------------------------------------------------------------+
bool ArrowLeftPriceDelete(const long   chart_ID=0,       // ID gráfico
                          const string name="LeftPrice") // nome etiqueta
  {
//--- redefine o valor de erro
   ResetLastError();
//--- excluir a etiqueta
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": falha ao excluir a etiqueta preço lado esquerda! Código de erro = ",GetLastError());
      return(false);
     }
//--- sucesso na execução
   return(true);
  }
//+------------------------------------------------------------------+
//| Verificar valores de ponto de ancoragem e definir valores padrão |
//| para aqueles vazios                                              |
//+------------------------------------------------------------------+
void ChangeArrowEmptyPointx(datetime &time,double &price)
  {
//--- se o tempo do ponto não está definido, será na barra atual
   if(!time)
      time=TimeCurrent();
//--- se o preço do ponto não está definido, ele terá valor Bid
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }