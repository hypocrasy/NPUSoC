#include<iostream>
#include<fstream>
using namespace std;
int main()
{
	ifstream result("C:\\Users\\zhangyang\\Desktop\\design_2021\\accelerator\\sim\\result.txt");
	ifstream stdresult("C:\\Users\\zhangyang\\Desktop\\design_2021\\accelerator\\sim\\stdresult.txt");
	int corect=0;
	for(int i=1;i<=1000;i++)
	{
		int a,b;
		result>>a;
		stdresult>>b;
		if(a==b) corect++;
	}
	cout<<"Accuracy:"<<(double)corect/1000.0*100<<"%";
	result.close();
	stdresult.close();
}
