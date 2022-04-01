#include<iostream>
#include<cmath>
#include <cstdlib>
#include <cstring>
//#include <conio.h>
#include <assert.h>
#include<fstream>
#include<vector>
using namespace std;
string Asm[3000];
string image[98];
int main(int argc, char **argv)
{
	//int num=c2i(argv[1]);
	//cout<<num<<"\n";
	/*char filename4[200];    
	ImgArr t10k_img;
	LabelArr t10k_label;
	strcpy(filename4,"t10k-images-idx3-ubyte");
	t10k_img=read_Img(filename4);*/
	//t10k_img->ImgNum=1;
	/*for(int num_img=0;num_img<t10k_img->ImgNum;num_img++){
	
	    char* name=(char*)malloc(100);
	    strcpy(name,"C:\\Users\\zhangyang\\Desktop\\design_2021\\accelerator\\image\\");
		//cout<<name;
	    //strcpy(name,argv[1]);
		string s=to_string(num_img);
		int len=s.length();
		char* tem=(char*)malloc(10);
		s.copy(tem,len,0);
		*(tem+len)='\0';
		strcat(name,tem);
	    //strcat(name,argv[1]);
	    strcat(name,".txt");
	    //cout<<name<<"\n";
		ofstream out(name);    
		    
		for(int i=0;i<784;i++){
			
	        	out<<round(t10k_img->ImgPtr[num_img].ImgData[i/28][i%28]/0.007874015718698502)<<" ";
	        	if((i+1)%8==0) out<<endl;
	                //printf("%lf",net_input[i]);
	    }
	}  */         
	
	ifstream demo("/mnt/c/Users/zhangyang/Desktop/design_2021/accelerator/asm/demo.asm");
	if(!demo)
    {
        cout<<"ERROE";
        return 0;
    }
	string s;
	int cnt=0;
	while(!demo.eof())
	{
		getline(demo,s);
		//cout<<s;
		Asm[cnt++]=s;
		//col++;
	}
	
	//cout<<1;
	demo.close();
	char name[100];
	
		strcpy(name,"/mnt/c/Users/zhangyang/Desktop/design_2021/accelerator/image/"); 
	
		strcat(name,argv[1]);
	
		strcat(name,".txt");
	cout<<name;	
	ifstream imagefile(name);
	if(!imagefile)cout<<"ERROR";
 	for(int i=0;i<98;i++)
	{
		getline(imagefile,s);
		Asm[271+i]=s;
	}
	imagefile.close();
	ofstream demo1("/mnt/c/Users/zhangyang/Desktop/design_2021/accelerator/asm/demo.asm");
    if(!demo1)
    {
        cout<<"outerror";
        return 0;
    }
	
	for(int i=0;i<cnt;i++){
		demo1<<Asm[i]<<endl;
	}
    cout<<"已经复制"<<cnt<<"行"<<"从"<<name<<endl;
	demo1.close();

	return 0;
}
