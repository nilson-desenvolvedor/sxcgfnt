//+------------------------------------------------------------------+
//|                                             ControlsCheckBox.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Control Panels and Dialogs. Demonstration class CCheckBox"
#include <Controls\Dialog.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
//#include <iostream>
//#include <cstdlib>
//#include <ctime>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate
//--- for buttons
#define BUTTON_WIDTH                        (100)     // size by X coordinate
#define BUTTON_HEIGHT                       (100)      // size by Y coordinate
//--- for the indication area
#define EDIT_HEIGHT                         (20)      // size by Y coordinate
//--- for group controls
#define GROUP_WIDTH                         (150)     // size by X coordinate
#define LIST_HEIGHT                         (179)     // size by Y coordinate
#define RADIO_HEIGHT                        (56)      // size by Y coordinate
#define CHECK_HEIGHT                        (93)      // size by Y coordinate
//+------------------------------------------------------------------+
//| Class CControlsDialog                                            |
//| Usage: main dialog of the Controls application                   |
//+------------------------------------------------------------------+
class CControlsDialog : public CAppDialog
  {
private:

public:
   CButton           m_button_1_1; 
   CButton           m_button_1_2; 
   CButton           m_button_1_3; 

   CButton           m_button_2_1; 
   CButton           m_button_2_2; 
   CButton           m_button_2_3; 

   CButton           m_button_3_1; 
   CButton           m_button_3_2; 
   CButton           m_button_3_3; 
   
   CButton           m_xou0;
   CButton           m_limpa;
   int               tabuleiro[3][3];// = {{0, 0, 0},{0, 0, 0},{0, 0, 0}};
   
   CLabel            m_label;                         // CLabel object
   int               v_usuario;
   int               v_maquina;




                     CControlsDialog(void);
                    ~CControlsDialog(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   
   void maquina_joga (void);
protected:
   //--- create dependent controls
   bool              CreateButton(void);
   //--- handlers of the dependent controls events


   void              OnClickButton_1_1(void);
   void              OnClickButton_1_2(void);
   void              OnClickButton_1_3(void);

   void              OnClickButton_2_1(void);
   void              OnClickButton_2_2(void);
   void              OnClickButton_2_3(void);

   void              OnClickButton_3_1(void);
   void              OnClickButton_3_2(void);
   void              OnClickButton_3_3(void);
   
   
   void              OnClickButton_xou0(void);
   void              OnClickButton_limpa(void);
   
   void              atualiza_tabuleiro(void);
   void              atualiza_botoes(void);
   int               termino(void);
   int               ganhador(void);


  };
  
  
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CControlsDialog)
ON_EVENT(ON_CLICK,m_button_1_1,OnClickButton_1_1)
ON_EVENT(ON_CLICK,m_button_1_2,OnClickButton_1_2)
ON_EVENT(ON_CLICK,m_button_1_3,OnClickButton_1_3)

ON_EVENT(ON_CLICK,m_button_2_1,OnClickButton_2_1)
ON_EVENT(ON_CLICK,m_button_2_2,OnClickButton_2_2)
ON_EVENT(ON_CLICK,m_button_2_3,OnClickButton_2_3)

ON_EVENT(ON_CLICK,m_button_3_1,OnClickButton_3_1)
ON_EVENT(ON_CLICK,m_button_3_2,OnClickButton_3_2)
ON_EVENT(ON_CLICK,m_button_3_3,OnClickButton_3_3)


ON_EVENT(ON_CLICK,m_xou0,OnClickButton_xou0)
ON_EVENT(ON_CLICK,m_limpa,OnClickButton_limpa)



EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CControlsDialog::CControlsDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CControlsDialog::~CControlsDialog(void)
  {
  }
  
int CControlsDialog::ganhador(void){
   //ganha linha 0
   if((tabuleiro[0][0]==tabuleiro[0][1])&&(tabuleiro[0][0]==tabuleiro[0][2])){
      if (tabuleiro[0][0]==1){
         return 1;
      }else if(tabuleiro[0][0]==-1){
         return -1;
      }
   }else
   //ganha linha 1
   if((tabuleiro[1][0]==tabuleiro[1][1])&&(tabuleiro[1][0]==tabuleiro[1][2])){
      if (tabuleiro[1][0]==1){
         return 1;
      }else if(tabuleiro[1][0]==-1){
         return -1;
      }
   }else
   //ganha linha 2
   if((tabuleiro[2][0]==tabuleiro[2][1])&&(tabuleiro[2][0]==tabuleiro[2][2])){
      if (tabuleiro[2][0]==1){
         return 1;
      }else if(tabuleiro[2][0]==-1){
         return -1;
      }
   }else
   //ganha coluna 0
   if((tabuleiro[0][0]==tabuleiro[1][0])&&(tabuleiro[0][0]==tabuleiro[2][0])){
      if (tabuleiro[0][0]==1){
         return 1;
      }else if(tabuleiro[0][0]==-1){
         return -1;
      }
   }else
   //ganha coluna 1
   if((tabuleiro[0][1]==tabuleiro[1][1])&&(tabuleiro[0][1]==tabuleiro[2][1])){
      if (tabuleiro[0][1]==1){
         return 1;
      }else if(tabuleiro[0][1]==-1){
         return -1;
      }
   }else
   //ganha coluna 2
   if((tabuleiro[0][2]==tabuleiro[1][2])&&(tabuleiro[0][2]==tabuleiro[2][2])){
      if (tabuleiro[0][2]==1){
         return 1;
      }else if(tabuleiro[0][2]==-1){
         return -1;
      }
   }else
   //ganha diagonal 1   
   if((tabuleiro[0][0]==tabuleiro[1][1])&&(tabuleiro[0][0]==tabuleiro[2][2])){
      if (tabuleiro[0][0]==1){
         return 1;
      }else if(tabuleiro[0][0]==-1){
         return -1;
      }
   }else
   //ganha diagonal 2
   if((tabuleiro[0][2]==tabuleiro[1][1])&&(tabuleiro[0][2]==tabuleiro[2][0])){
      if (tabuleiro[0][2]==1){
         return 1;
      }else if(tabuleiro[0][2]==-1){
         return -1;
      }
   }
   
   return 0;

}
  
int CControlsDialog::termino(void) {
   int i, j;
   bool vazio = false;
   for (i=0; i<=2; i++){
      for (j=0; j<=2; j++){
         Print("tabuleiro["+i+"]["+j+"]="+tabuleiro[i][j]);
         if (tabuleiro[i][j] == 0){           
            vazio = true;
         }
      }
         
   }
   
   m_label.Text("Maquinas "+v_maquina+", Usuario "+v_usuario);
   
   
   return vazio ? 0 : -1;

}
  
int aleatorio (int x){
   int c = 0 + MathRand() % 3;  
   return c;
   


}
  
void CControlsDialog::maquina_joga(void){
   if (m_xou0.Text()!="X") return;
   

   int linha = 0;
   int coluna = 0;
   
   
   bool sortear = true;
   

   
   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }
   
   if(termino() == -1){
      Print("casas cheias");
      return;
   }
   
   while (sortear){
      linha = aleatorio(3);
      coluna = aleatorio(3);   
      
      Print("Tentar "+linha+", "+coluna);
      if(tabuleiro[linha][coluna]!=0){ 
         sortear = true;
      } else{ sortear = false;}
      

      
   
   }
   
   tabuleiro[linha][coluna] = 1;
   
   atualiza_botoes();
   
   m_xou0.Text("0");
   m_xou0.Pressed(false);
}
  
void CControlsDialog::atualiza_botoes(void){

   

   m_button_1_1.Text(tabuleiro[0][0]==0?"":(tabuleiro[0][0]==-1?"0":"X"));
   m_button_1_2.Text(tabuleiro[0][1]==0?"":(tabuleiro[0][1]==-1?"0":"X"));
   m_button_1_3.Text(tabuleiro[0][2]==0?"":(tabuleiro[0][2]==-1?"0":"X"));

   m_button_2_1.Text(tabuleiro[1][0]==0?"":(tabuleiro[1][0]==-1?"0":"X"));
   m_button_2_2.Text(tabuleiro[1][1]==0?"":(tabuleiro[1][1]==-1?"0":"X"));
   m_button_2_3.Text(tabuleiro[1][2]==0?"":(tabuleiro[1][2]==-1?"0":"X"));

   m_button_3_1.Text(tabuleiro[2][0]==0?"":(tabuleiro[2][0]==-1?"0":"X"));
   m_button_3_2.Text(tabuleiro[2][1]==0?"":(tabuleiro[2][1]==-1?"0":"X"));
   m_button_3_3.Text(tabuleiro[2][2]==0?"":(tabuleiro[2][2]==-1?"0":"X"));
   

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
         v_maquina++;
      }else{
         Print ("Usuario Venceu");
         v_usuario++;
      }
      
   }
   
   m_label.Text("Maquinas "+v_maquina+", Usuario "+v_usuario);




}
  
void CControlsDialog::atualiza_tabuleiro(void){

   tabuleiro[0][0]= m_button_1_1.Text()==""?0:(m_button_1_1.Text()=="0"?-1:1);
   tabuleiro[0][1]= m_button_1_2.Text()==""?0:(m_button_1_2.Text()=="0"?-1:1);
   tabuleiro[0][2]= m_button_1_3.Text()==""?0:(m_button_1_3.Text()=="0"?-1:1);

   tabuleiro[1][0]= m_button_2_1.Text()==""?0:(m_button_2_1.Text()=="0"?-1:1);
   tabuleiro[1][1]= m_button_2_2.Text()==""?0:(m_button_2_2.Text()=="0"?-1:1);
   tabuleiro[1][2]= m_button_2_3.Text()==""?0:(m_button_2_3.Text()=="0"?-1:1);

   tabuleiro[2][0]= m_button_3_1.Text()==""?0:(m_button_3_1.Text()=="0"?-1:1);
   tabuleiro[2][1]= m_button_3_2.Text()==""?0:(m_button_3_2.Text()=="0"?-1:1);
   tabuleiro[2][2]= m_button_3_3.Text()==""?0:(m_button_3_3.Text()=="0"?-1:1);
   
   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
         v_maquina++;
      }else{
         Print ("Usuario Venceu");
         v_usuario++;
      }
      
   }  


}
  
void CControlsDialog::OnClickButton_1_1(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }

   if(m_button_1_1.Text()==""){
      m_button_1_1.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   
   atualiza_tabuleiro();
   maquina_joga();
   
} 
void CControlsDialog::OnClickButton_1_2(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_1_2.Text()==""){
      m_button_1_2.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   
   atualiza_tabuleiro();
   maquina_joga();

} 
void CControlsDialog::OnClickButton_1_3(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_1_3.Text()==""){
      m_button_1_3.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();

} 

void CControlsDialog::OnClickButton_2_1(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_2_1.Text()==""){
      m_button_2_1.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();
} 
void CControlsDialog::OnClickButton_2_2(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_2_2.Text()==""){
      m_button_2_2.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();

} 
void CControlsDialog::OnClickButton_2_3(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_2_3.Text()==""){
      m_button_2_3.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();

} 

void CControlsDialog::OnClickButton_3_1(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_3_1.Text()==""){
      m_button_3_1.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();

} 
void CControlsDialog::OnClickButton_3_2(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_3_2.Text()==""){
      m_button_3_2.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();

} 
void CControlsDialog::OnClickButton_3_3(void){

   if(ganhador()!=0){
      if (ganhador()==1){
         Print("Maquina Venceu");
      }else{
         Print ("Usuario Venceu");
      }
      return;
   }


   if(m_button_3_3.Text()==""){
      m_button_3_3.Text(m_xou0.Text());
      
      if(m_xou0.Pressed()){
         m_xou0.Pressed(false);
         m_xou0.Text("0");
      }else{
         m_xou0.Pressed(true);
         m_xou0.Text("X");
      }
   }else{
   }
   atualiza_tabuleiro();
   maquina_joga();

} 



  
void CControlsDialog::OnClickButton_xou0(void){
   if (m_xou0.Pressed()){
      m_xou0.Text("X");
   }else{
      m_xou0.Text("0");
   }
   
  
}  

void CControlsDialog::OnClickButton_limpa(void){
   m_button_1_1.Text("");
   m_button_1_2.Text("");
   m_button_1_3.Text("");
   
   m_button_2_1.Text("");
   m_button_2_2.Text("");
   m_button_2_3.Text("");
   
   m_button_3_1.Text("");
   m_button_3_2.Text("");
   m_button_3_3.Text("");
   
   atualiza_tabuleiro();
   maquina_joga();
   

}  


bool CControlsDialog::CreateButton(void)
  {
  
  v_usuario = 0;
  v_maquina = 0;
  
  
//--- coordinates  
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+BUTTON_WIDTH;
   int y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_1_1.Create(m_chart_id,m_name+"b11",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_1_1.Text(""))
      return(false);
   if(!Add(m_button_1_1))
      return(false);
      
//--- coordinates
   x1=INDENT_LEFT+BUTTON_WIDTH+10;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_1_2.Create(m_chart_id,m_name+"b12",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_1_2.Text(""))
      return(false);
   if(!Add(m_button_1_2))
      return(false);

      
//--- coordinates
   x1=INDENT_LEFT+BUTTON_WIDTH+10+BUTTON_WIDTH+10;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_1_3.Create(m_chart_id,m_name+"b13",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_1_3.Text(""))
      return(false);
   if(!Add(m_button_1_3))
      return(false);



//--- coordinates
   x1=INDENT_LEFT;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+BUTTON_HEIGHT+10;
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_2_1.Create(m_chart_id,m_name+"b21",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_2_1.Text(""))
      return(false);
   if(!Add(m_button_2_1))
      return(false);
      
//--- coordinates
   x1=INDENT_LEFT+BUTTON_WIDTH+10;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+BUTTON_HEIGHT+10;
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_2_2.Create(m_chart_id,m_name+"b22",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_2_2.Text(""))
      return(false);
   if(!Add(m_button_2_2))
      return(false);

      
//--- coordinates
   x1=INDENT_LEFT+BUTTON_WIDTH+10+BUTTON_WIDTH+10;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+BUTTON_HEIGHT+10;
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_2_3.Create(m_chart_id,m_name+"b23",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_2_3.Text(""))
      return(false);
   if(!Add(m_button_2_3))
      return(false);



//--- coordinates
   x1=INDENT_LEFT;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+BUTTON_HEIGHT+10+BUTTON_HEIGHT+10;
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_3_1.Create(m_chart_id,m_name+"b31",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_3_1.Text(""))
      return(false);
   if(!Add(m_button_3_1))
      return(false);
      
//--- coordinates
   x1=INDENT_LEFT+BUTTON_WIDTH+10;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+BUTTON_HEIGHT+10+BUTTON_HEIGHT+10;
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_3_2.Create(m_chart_id,m_name+"b32",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_3_2.Text(""))
      return(false);
   if(!Add(m_button_3_2))
      return(false);

      
//--- 

   x1=INDENT_LEFT+BUTTON_WIDTH+10+BUTTON_WIDTH+10;
   y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y)+BUTTON_HEIGHT+10+BUTTON_HEIGHT+10;
   x2=x1+BUTTON_WIDTH;
   y2=y1+BUTTON_HEIGHT;
//--- create
   if(!m_button_3_3.Create(m_chart_id,m_name+"b33",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button_3_3.Text(""))
      return(false);
   if(!Add(m_button_3_3))
      return(false);
      

//--- coordinates botao x ou 0
   x1=INDENT_LEFT;
   y1=INDENT_TOP+380;
   x2=x1+100;
   y2=y1+30;
//--- create
   if(!m_xou0.Create(m_chart_id,m_name+"m_xou0",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_xou0.Text("0"))
      return(false);
   if(!Add(m_xou0))
      return(false);
   m_xou0.Locking(true);

//--- coordinates botao x ou 0
   x1=INDENT_LEFT+120;
   y1=INDENT_TOP+380;
   x2=x1+100;
   y2=y1+30;
//--- create
   if(!m_limpa.Create(m_chart_id,m_name+"m_limpa",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_limpa.Text("Inicia"))
      return(false);
   if(!Add(m_limpa))
      return(false);
   m_xou0.Locking(true);


   if(!m_label.Create(m_chart_id,m_name+"lable",m_subwin,x2+40,y1,x2,y2))
      return(false);
   if(!m_label.Text("0 a 0"))
      return(false);
   if(!Add(m_label))
      return(false);



//--- succeed
   return(true);
  }
  
void OnTimer(){
   
   ExtDialog.m_label.Text("Maquinas "+ExtDialog.v_maquina+", Usuario "+ExtDialog.v_usuario);

}
  
  
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
      
      
   int i, j;
   
   for (i=1; i<=2; i++){
      for (j=1; j<=2; j++){
         tabuleiro[i][j] = 0;
      }
   }
      
      

         
   
   

//--- create dependent controls

   

      
   if(!CreateButton())
      return(false);
//--- succeed
   return(true);
  }



//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
CControlsDialog ExtDialog;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
  EventSetTimer(3);
  
   //apagar todos os bjetos
   ObjectsDeleteAll(0, 0);
//--- create application dialog
   if(!ExtDialog.Create(0,"Controls",0,40,40,700,500))
      return(INIT_FAILED);
//--- run application
   ExtDialog.Run();
//--- succeed
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("");
//--- destroy dialog
   ExtDialog.Destroy(reason);
  }
//+------------------------------------------------------------------+
//| Expert chart event function                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // event ID  
                  const long& lparam,   // event parameter of the long type
                  const double& dparam, // event parameter of the double type
                  const string& sparam) // event parameter of the string type
  {
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);
  }