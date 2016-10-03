class G_table {
  Table[] ts;
  int[] sums,likes;
  int N,R,C,tablesMaxSum;
  String[] titles;
  
  //CONSTRUCTOR
  G_table (int N){
    
    // group table initialization

    ts  =  new Table[this.N=N];   
    
    for(int i=0;i<N;i++){
      ts[i]= new Table(i); 
    }
    
    R= ts[0].getNumRows()-1;  
    C= ts[0].getNumCols()-1;  
    
    //data necessary for the displaying of the button row as visualization
    tablesMaxSum  = 0;                
    titles        = new String[N];   
    likes         = new int[N];  
    sums          = new int[N];       

    for(int i=0;i<N;i++){
      sums[i]       = ts[i].totalSum();
      likes[i]      = ts[i].colSum(1);
      tablesMaxSum  = sums[i]>tablesMaxSum?sums[i]:tablesMaxSum; 
      titles[i]     = ts[i].getString(0,0);   //<>//
  }
    
  }
  
  //METHODS
  int getSums(int index){
      return sums[index];
    }
  int getMaxSum(){
      return tablesMaxSum;
    }
  String getTitle(int index){
      return titles[index];
    }
  
  Table get(int index){
      return ts[index];
    }   
  
  int getRows(int tableNum){

    return ts[tableNum].getNumRows()-1;
}
  int getCols(int tableNum){
    return ts[tableNum].getNumCols()-1;
  }
  int getN(){
    return N;
  }
  
  String[] getTitles(){return titles;}
  int[] getSums(){return sums;}
  
}  