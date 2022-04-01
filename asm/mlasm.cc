
#include "mlasm.h"
#include <iostream>
#include <string.h>
std::string itos(int tem)
{
	//int tem=stoi(s)+a;
	std::string s;
	while(tem)
	{
		s+=tem%10+'0';
		tem/=10;
	}
	
	s = std::string(s.rbegin(), s.rend());
	return s;
		
}
std::string stringadd(std::string s,int a)
{
	int tem=std::stoi(s)+a;
	std::string b=itos(tem);

	//=std::__cxx11::to_string(tem);
	return b;
		
}
void itoc(int a,char* b)
{
	int cnt=-1;
	if(!a)
	{
		b[0]='0';
		b[1]='\0';                          
		return;
	}
	while(a)
	{
		b[++cnt]=a%10+'0';
		a/=10;
	}
	//cout<<b[0];
	b[cnt+1]='\0';
	for(int i=0;i<=cnt/2;i++)
	{
		char tem=b[i];
		b[i]=b[cnt-i];
		b[cnt-i]=tem;
	}
	return;
}
void MlAsm::parseArg(const std::string &s, field_t field, int factor, int divider)
{
	for (int i = 1; i < int(s.size()); i++)
	{
		if (s[i] == '+' || s[i] == '-')
		{
			parseArg(s.substr(0, i), field, factor);
			parseArg(s.substr(i), field, factor);
			return;
		}
	}

	const char *p = s.c_str();
	int poffset = 0;

	if (*p == '-')
	{
		factor *= -1;
		poffset = 1;
		p++;
	}
	else if (*p == '+')
	{
		poffset = 1;
		p++;
	}

	int scan_start = strlen(p) - 1;
	for (int i = scan_start; i > 0; i--)
	{
		if (p[i] == '*' && i < scan_start)
		{
			parseArg(s.substr(poffset, i), field,
					 factor * atoi(p + i + 1), divider);
			return;
		}
		if (p[i] == '/' && i < scan_start)
		{
			parseArg(s.substr(poffset, i), field,
					 factor, divider * atoi(p + i + 1));
			return;
		}
		if (p[i] < '0' || p[i] > '9')
			break;
	}

	char *endptr = nullptr;
	int val = strtol(p, &endptr, 0) * factor;

	if (!endptr || *endptr)
	{
		symaction_t act;
		act.insn_idx = insns.size() - 1;
		act.factor = factor;
		act.divider = divider;
		act.field = field;
		symbols[p].actions.push_back(act);
	}
	else
	{
		auto &insn = insns.back();

		if (field == FIELD_MADDR)
			insn.maddr += val;

		if (field == FIELD_CADDR)
			insn.caddr += val;
	}
}
void MlAsm::pretreat(const char *line)
{
	char *strtok_saveptr;
	char *p = strdup(line);

	char *cmd_p = strtok_r(p, " \t\r\n", &strtok_saveptr);
	std::string cmd = cmd_p ? cmd_p : "";
	std::vector<std::string> args;
	

	while (1)
	{
		const char *args_delim = " ,\r\n\t";

		if (state == STATE_DATA || cmd.empty() || cmd[0] == '.')
			args_delim = " \t\r\n";

		char *t = strtok_r(nullptr, args_delim, &strtok_saveptr);
	
		if (t == nullptr)
			break;
		args.push_back(t);
	}

	if (cmd == "multis") //矩阵乘向量
	{
		if (args.size() != 4)
		{
			fprintf(stderr, "MlAsm syntax error in line %d: %s\n", linenr, line);
			exit(1);
		}
		std::string indataaddr = args[0];//indata的起始位置
		std::string coeffaddr = args[1];//coeff的起始位置
		std::string length = args[2]; //单维向量的长度(实际是8*length)
		std::string times = args[3];  //多维向量的维度
		//std::string storage=args[4];
		int intlength=std::stoi(length,NULL,0);
		int inttimes=std::stoi(times,NULL,0);
		char a[200];
		//int offset=0;
		char int2string[10];
		for(int i=0;i<inttimes/2+(inttimes%2==1);i++)
		{
			itoc(i*2*intlength*8,int2string);
			strcpy(a, "LoadCoeff0 ");
			strcat(a, coeffaddr.c_str());
			strcat(a,"+");
			strcat(a,int2string);
			strcat(a,",");
			strcat(a,"0");
			pretreat(a);
			if(intlength>1)
			{
				itoc(intlength-1,int2string);
				strcpy(a,"ContinueLoad ");
				strcat(a,int2string);
				pretreat(a);
			}
			
			//offset+=intlength*8;
			
			itoc((i*2+1)*intlength*8,int2string);
			strcpy(a, "LoadCoeff1 ");
			strcat(a, coeffaddr.c_str());
			strcat(a,"+");
			strcat(a,int2string);
			strcat(a,",");
			strcat(a,"0");
			pretreat(a);
			
			if(intlength>1)
			{
				itoc(intlength-1,int2string);
				strcpy(a,"ContinueLoad ");
				strcat(a,int2string);
				pretreat(a);
			}

			//offset+=intlength*8;
			
			pretreat("SetCBP 0");
			strcpy(a,"SetVBP ");
			strcat(a,indataaddr.c_str());
			pretreat(a);
			pretreat("MACCZ 0,0");
			pretreat("AddVBP 8");
			pretreat("AddCBP 1");
			strcpy(a,"multi 0,0,");
			
			strcat(a,stringadd(length,-1).c_str());
			pretreat(a);

			strcpy(a,"Save ");
			itoc(i*8,int2string);
			strcat(a,int2string);
			pretreat(a);
			

		}
		
		/*if(inttimes%2)
		{
			itoc(inttimes*8*intlength,int2string);
			strcpy(a, "LoadCoeff0 ");
			strcat(a, coeffaddr.c_str());
			strcat(a,"+");
			strcat(a,int2string);
			strcat(a,",");
			strcat(a,"0");
			pretreat(a);
			if(intlength>1)
			{
				itoc(intlength-1,int2string);
				strcpy(a,"ContinueLoad ");
				strcat(a,int2string);
				pretreat(a);
			}
			pretreat("SetCBP 0");
			strcpy(a,"SetVBP ");
			strcat(a,indataaddr.c_str());
			pretreat(a);
			pretreat("MACCZ 0,0");
			strcpy(a,"multi 0,0,");
			
			strcat(a,stringadd(length,-1).c_str());
			pretreat(a);

			strcpy(a,"Save ");
			itoc(inttimes*4,int2string);
			strcat(a,int2string);
			pretreat(a);
		}*/
		//pretreat(a);
		//strcpy(a,"AddCBP ");
		//strcat(a,coeffaddr.c_str());
		return;
	}
	if (cmd == "multi") //两个向量点乘
	{
		if (args.size() != 3)
		{
			fprintf(stderr, "MlAsm syntax error in line %d: %s\n", linenr, line);
			exit(1);
		}
		std::string maddroffset = args[0];
		std::string caddroffset = args[1];
		int num = std::stoi(args[2]);
		char a[200];
		strcpy(a, "AddVBP ");
		strcat(a, maddroffset.c_str());
		pretreat(a);
		strcpy(a, "AddCBP ");
		strcat(a, caddroffset.c_str());
		pretreat(a);
		for (int i = 1; i <= num / 10; i++)
		{
			pretreat("Execute 0, run_multiply_10time_end/4-run_multiply_10time_begin/4");
		}
		strcpy(a, "Execute 0, run_multiply_10time_end/4-run_multiply_10time_begin/4-");
		int bias = (10 - num % 10) * 3;
		char ones[2];
		ones[0] = bias % 10 + '0';
		ones[1] = '\0';
		char tens[2];
		tens[0] = bias / 10 + '0';
		tens[1] = '\0';
		//std::cout<<tens<<"\n";
		if (tens[0] != '0')
			strcat(a, tens);

		strcat(a, ones);
		//std::cout<<a;
		//std::cout<<a;
		pretreat(a);
		/*strcpy(a, "AddVBP -(");
		strcat(a, maddroffset.c_str());
		strcat(a, ")");
		pretreat(a);
		strcpy(a, "AddCBP -(");
		strcat(a, caddroffset.c_str());
		strcat(a, ")");
		pretreat(a);*/
		return;
	}
	if (cmd == ".code")
	{
		parseLine(line);
		pretreat("LoadCode run_multiply_10time_begin, 0");
		pretreat("ContinueLoad run_multiply_10time_end/4-run_multiply_10time_begin/4-1");
		pretreat("LoadCode run_32b_multi_10_begin,50");
		pretreat("ContinueLoad run_32b_multi_10_end/4-run_32b_multi_10_begin/4-1");
		return;
	}
	if (cmd == ".data")
	{
		pretreat("run_multiply_10time_begin:");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("MACC 0,0");
		pretreat("AddVBP 8");
		pretreat("AddCBP 1");
		pretreat("run_multiply_10time_end:");
		pretreat("run_32b_multi_10_begin:");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("LdAdd 0");
		pretreat("run_32b_multi_10_end:");
		parseLine(line);
		return;
	}
	if (cmd == "Add")
	{
		if (args.size() != 2)//第一个参数地址，第二个是加的次数
		{
			fprintf(stderr, "MlAsm syntax error in line %d: %s\n", linenr, line);
			exit(1);
		}
		char a[200];
		strcpy(a, "AddLBP ");
		strcat(a, args[0].c_str());
		pretreat(a);
		int num = std::stoi(args[1]);
		for (int i = 1; i <= num / 10; i++)
		{
			pretreat("Execute 50,run_32b_multi_10_end/4-run_32b_multi_10_begin/4");
		}
		strcpy(a, "Execute 50,run_32b_multi_10_end/4-run_32b_multi_10_begin/4-");
		int bias = (10 - num % 10);
		char ones[2];
		ones[0] = bias % 10 + '0';
		ones[1] = '\0';
		strcat(a, ones);
		pretreat(a);
		/*strcpy(a, "AddLBP -(");
		strcat(a, args[0].c_str());
		strcat(a,")");
		pretreat(a);*/
		return;
	}
	parseLine(line);
}
void MlAsm::parseLine(const char *line)
{

	std::cout << line << "\n";
	//std::cout<<"enter:";
	char *strtok_saveptr;
	char *p = strdup(line);

	char *cmd_p = strtok_r(p, " \t\r\n", &strtok_saveptr);
	std::string cmd = cmd_p ? cmd_p : "";
	std::vector<std::string> args;

	while (1)
	{
		const char *args_delim = ",\r\n";

		if (state == STATE_DATA || cmd.empty() || cmd[0] == '.')
			args_delim = " \t\r\n";

		char *t = strtok_r(nullptr, args_delim, &strtok_saveptr);

		if (t == nullptr)
			break;

		for (int i = 0, j = 0;; i++)
		{
			t[j] = t[i];
			if (t[i] != ' ' && t[i] != '\t')
				j++;
			if (t[i] == 0)
				break;
		}
		//std::cout<<t<<"\n";
		args.push_back(t);
	}

	linenr++;
	free(p);

	if (cmd == "")
		return;

	if (cmd == "//" || cmd[0] == '#')
		return;

	if (cmd == ".sym" && args.size() == 2)
	{
		char *endptr = nullptr;
		int p = strtol(args[1].c_str(), &endptr, 0);
		if (!endptr || *endptr)
			goto syntax_error;

		symbols[args[0]].position = p;
		return;
	}

	if (cmd == ".code" || cmd == ".data")
	{
		if (cmd == ".code")
			state = STATE_CODE;
		else
			state = STATE_DATA;

		if (args.size() > 1)
			goto syntax_error;

		if (args.size() == 1)
		{
			char *endptr = nullptr;
			int p = strtol(args[0].c_str(), &endptr, 0);
			if (!endptr || *endptr)
				goto syntax_error;

			if (cursor > p)
			{
				fprintf(stderr, "MlAsm cursor error in line %d: New position is %d "
								"but cursor is already at %d\n",
						linenr, p, cursor);
				exit(1);
			}

			if (p % 4 != 0)
			{
				fprintf(stderr, "MlAsm cursor error in line %d: New position %d is "
								"not divisible by 4.\n",
						linenr, p);
				exit(1);
			}

			cursor = p;
		}

		return;
	}

	if (cmd.size() > 1 && cmd[cmd.size() - 1] == ':' && args.size() == 0)
	{
		std::string sym = cmd.substr(0, cmd.size() - 1);

		if (symbols[sym].position != -1)
		{
			fprintf(stderr, "MlAsm symbol error in line %d: Multiple definitions of "
							"symbol %s.\n",
					linenr, sym.c_str());
			exit(1);
		}

		symbols[sym].position = cursor;
		return;
	}

	if (state == STATE_CODE)
	{
		insns.push_back(insn_t());
		auto &insn = insns.back();

		insn.position = cursor;
		cursor += 4;

		if (cmd == "Sync" && args.size() == 0)
		{
			insn.opcode = 0;
			return;
		}

		if (cmd == "Call" && args.size() == 1)
		{
			insn.opcode = 1;
			parseArg(args[0], FIELD_MADDR);
			return;
		}

		if (cmd == "Return" && args.size() == 0)
		{
			insn.opcode = 2;
			return;
		}

		if (cmd == "Execute" && args.size() == 2)
		{
			insn.opcode = 3;
			parseArg(args[0], FIELD_CADDR);
			parseArg(args[1], FIELD_MADDR);
			return;
		}

		if (cmd == "LoadCode" && args.size() == 2)
		{
			insn.opcode = 4;
			parseArg(args[0], FIELD_MADDR);
			parseArg(args[1], FIELD_CADDR);
			return;
		}

		if (cmd == "LoadCoeff0" && args.size() == 2)
		{
			insn.opcode = 5;
			parseArg(args[0], FIELD_MADDR);
			parseArg(args[1], FIELD_CADDR);
			return;
		}

		if (cmd == "LoadCoeff1" && args.size() == 2)
		{
			insn.opcode = 6;
			parseArg(args[0], FIELD_MADDR);
			parseArg(args[1], FIELD_CADDR);
			return;
		}

		if (cmd == "ContinueLoad" && args.size() == 1)
		{
			insn.opcode = 7;
			parseArg(args[0], FIELD_MADDR);
			return;
		}

		if ((cmd == "SetVBP" || cmd == "AddVBP" || cmd == "SetLBP" || cmd == "AddLBP" || cmd == "SetSBP" || cmd == "AddSBP") && args.size() == 1)
		{
			if (cmd == "SetVBP")
				insn.opcode = 8;

			if (cmd == "AddVBP")
				insn.opcode = 9;

			if (cmd == "SetLBP")
				insn.opcode = 10;

			if (cmd == "AddLBP")
				insn.opcode = 11;

			if (cmd == "SetSBP")
				insn.opcode = 12;

			if (cmd == "AddSBP")
				insn.opcode = 13;

			parseArg(args[0], FIELD_MADDR);
			return;
		}

		if ((cmd == "SetCBP" || cmd == "AddCBP") && args.size() == 1)
		{
			if (cmd == "SetCBP")
				insn.opcode = 14;

			if (cmd == "AddCBP")
				insn.opcode = 15;

			parseArg(args[0], FIELD_CADDR);
			return;
		}

		if ((cmd == "Store" || cmd == "Store0" || cmd == "Store1" ||
			 cmd == "ReLU" || cmd == "ReLU0" || cmd == "ReLU1") &&
			args.size() == 2)
		{
			if (cmd == "Store")
				insn.opcode = 16;

			if (cmd == "Store0")
				insn.opcode = 17;

			if (cmd == "Store1")
				insn.opcode = 18;

			if (cmd == "ReLU")
				insn.opcode = 20;

			if (cmd == "ReLU0")
				insn.opcode = 21;

			if (cmd == "ReLU1")
				insn.opcode = 22;
			if (cmd == "ReLUs")
				insn.opcode = 23;

			parseArg(args[0], FIELD_MADDR);
			parseArg(args[1], FIELD_CADDR);
			return;
		}

		if ((cmd == "Save" || cmd == "Save0" || cmd == "Save1" ||
			 cmd == "LdSet" || cmd == "LdSet0" || cmd == "LdSet1" ||
			 cmd == "LdAdd" || cmd == "LdAdd0" || cmd == "LdAdd1") &&
			args.size() == 1)
		{
			if (cmd == "Save")
				insn.opcode = 24;

			if (cmd == "Save0")
				insn.opcode = 25;

			if (cmd == "Save1")
				insn.opcode = 26;

			if (cmd == "LdSet")
				insn.opcode = 28;

			if (cmd == "LdSet0")
				insn.opcode = 29;

			if (cmd == "LdSet1")
				insn.opcode = 30;

			if (cmd == "LdAdd")
				insn.opcode = 32;

			if (cmd == "LdAdd0")
				insn.opcode = 33;

			if (cmd == "LdAdd1")
				insn.opcode = 34;

			parseArg(args[0], FIELD_MADDR);
			return;
		}

		if ((cmd == "MACC" || cmd == "MMAX" || cmd == "MACCZ" || cmd == "MMAXZ" || cmd == "MMAXN") && args.size() == 2)
		{
			if (cmd == "MACC")
				insn.opcode = 40;

			if (cmd == "MMAX")
				insn.opcode = 41;

			if (cmd == "MACCZ")
				insn.opcode = 42;

			if (cmd == "MMAXZ")
				insn.opcode = 43;

			if (cmd == "MMAXN")
				insn.opcode = 45;

			parseArg(args[0], FIELD_MADDR);
			parseArg(args[1], FIELD_CADDR);
			return;
		}

		insns.pop_back();
		cursor -= 4;
	}

	if (state == STATE_DATA)
	{
		args.insert(args.begin(), cmd);

		if (args.size() % 4 != 0)
		{
			fprintf(stderr, "MlAsm data error in line %d: Data section must contain "
							"multiples of 4 bytes per lines.\n",
					linenr);
			exit(1);
		}

		for (int i = 0; i < int(args.size()); i += 4)
		{
			uint32_t w = 0;

			for (int j = 0; j < 4; j++)
			{
				char *endptr = nullptr;
				uint8_t v = strtol(args[i + j].c_str(), &endptr, 0);

				if (!endptr || *endptr)
					goto syntax_error;

				w |= v << (j * 8);
			}

			data[cursor / 4] = w;
			data_valid[cursor / 4] = true;
			cursor += 4;
		}

		return;
	}

syntax_error:
	fprintf(stderr, "MlAsm syntax error in line %d: %s\n", linenr, line);
	exit(1);
}

void MlAsm::assemble()
{
	for (auto &sym_it : symbols)
	{
		auto &sym_name = sym_it.first;
		auto &sym = sym_it.second;

		if (sym.position < 0)
		{
			fprintf(stderr, "MlAsm symbol error: Symbol %s is used but not defined.\n",
					sym_name.c_str());
			exit(1);
		}

		if (verbose)
			printf("symbol %s at %d (0x%05x).\n", sym_name.c_str(), sym.position, sym.position);

		for (auto &act : sym.actions)
		{
			auto &insn = insns[act.insn_idx];
			int val = sym.position * act.factor;

			if (val % act.divider != 0)
			{
				fprintf(stderr, "MlAsm symbol error: Symbol %s is divided by %d but is not a multiple of %d (%d).\n",
						sym_name.c_str(), act.divider, act.divider, val);
				exit(1);
			}

			val /= act.divider;

			if (act.field == FIELD_MADDR)
				insn.maddr += val;

			if (act.field == FIELD_CADDR)
				insn.caddr += val;
		}
	}

	for (auto &insn : insns)
	{
		uint32_t maddr = insn.maddr & 0x1ffff;
		uint32_t caddr = insn.caddr & 0x1ff;
		uint32_t opcode = insn.opcode & 0x3f;

		data.at(insn.position / 4) = (maddr << 15) | (caddr << 6) | opcode;
		data_valid.at(insn.position / 4) = true;
	}
}

void MlAsm::writeHexFile(FILE *f)
{
	bool print_addr = true;

	for (int i = 0; i < cursor; i += 4)
	{
		if (!data_valid[i / 4])
		{
			print_addr = true;
		}
		else
		{
			if (print_addr)
			{
				if (verbose)
					printf("new hex file section at 0x%05x.\n", i);
				fprintf(f, "@%05x\n", i);
			}

			uint8_t a = data[i / 4];
			uint8_t b = data[i / 4] >> 8;
			uint8_t c = data[i / 4] >> 16;
			uint8_t d = data[i / 4] >> 24;

			fprintf(f, "%02x %02x %02x %02x\n", a, b, c, d);
			print_addr = false;
		}
	}
}

void MlAsm::writeBinFile(FILE *f)
{
	int sz = int(data_valid.size());

	while (sz > 0 && !data_valid[sz - 1])
		sz--;

	if (verbose)
		printf("writing %d bytes bin file.\n", 4 * sz);

	uint8_t buffer[4 * sz];

	for (int i = 0; i < sz; i++)
	{
		buffer[4 * i + 0] = data[i];
		buffer[4 * i + 1] = data[i] >> 8;
		buffer[4 * i + 2] = data[i] >> 16;
		buffer[4 * i + 3] = data[i] >> 24;
	}

	fwrite(buffer, 4 * sz, 1, f);
}
