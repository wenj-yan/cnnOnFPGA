module floatAdd16 (floatA,floatB,sum);
	
input [15:0] floatA, floatB;  // ����float16����A��B
output reg [15:0] sum;   // ���Ϊfloat16����sum

reg sign; // �����������־λ
reg signed [5:0] exponent; //������ݵ�ָ������������ѡ���з�����
reg [9:0] mantissa; //������ݵ�β��
reg [4:0] exponentA, exponentB; //������ݵĽ���
reg [10:0] fractionA, fractionB, fraction;	//fraction = {1,mantissa} �ݴ�λ
reg [7:0] shiftAmount;// ��λ�Ĵ���������ӷ�ʱ��ƽ����
reg cout;

always @ (floatA or floatB) begin
	exponentA = floatA[14:10];
	exponentB = floatB[14:10];
	fractionA = {1'b1,floatA[9:0]};
	fractionB = {1'b1,floatB[9:0]}; 
	
	exponent = exponentA;

	if (floatA == 0) begin						//special case (floatA = 0)
		sum = floatB;
	end else if (floatB == 0) begin					//special case (floatB = 0)
		sum = floatA;
	end else if (floatA[14:0] == floatB[14:0] && floatA[15]^floatB[15]==1'b1) begin //A��B��Ϊ�෴�������
		sum=0;
	end else begin
		if (exponentB > exponentA) begin   // ��ƽ������ʹ��A��B��ͬһ����
			shiftAmount = exponentB - exponentA;
			fractionA = fractionA >> (shiftAmount);
			exponent = exponentB;
		end else if (exponentA > exponentB) begin 
			shiftAmount = exponentA - exponentB;
			fractionB = fractionB >> (shiftAmount);
			exponent = exponentA;
		end
		if (floatA[15] == floatB[15]) begin			//A��Bͬ����
			{cout,fraction} = fractionA + fractionB;
			if (cout == 1'b1) begin
				{cout,fraction} = {cout,fraction} >> 1;
				exponent = exponent + 1;
			end
			sign = floatA[15];
		end else begin						//A��B���Ų���ͬ
			if (floatA[15] == 1'b1) begin   // AΪ����
				{cout,fraction} = fractionB - fractionA;  // B-A 
			end else begin
				{cout,fraction} = fractionA - fractionB;  // A-B
			end
			sign = cout;
			if (cout == 1'b1) begin
				fraction = -fraction;  // 0-��������������ľ���ֵ
			end else begin
			end
			//��franction���н�����ƽ�����β��
			if (fraction [10] == 0) begin
				if (fraction[9] == 1'b1) begin
					fraction = fraction << 1;
					exponent = exponent - 1;
				end else if (fraction[8] == 1'b1) begin
					fraction = fraction << 2;
					exponent = exponent - 2;
				end else if (fraction[7] == 1'b1) begin
					fraction = fraction << 3;
					exponent = exponent - 3;
				end else if (fraction[6] == 1'b1) begin
					fraction = fraction << 4;
					exponent = exponent - 4;
				end else if (fraction[5] == 1'b1) begin
					fraction = fraction << 5;
					exponent = exponent - 5;
				end else if (fraction[4] == 1'b1) begin
					fraction = fraction << 6;
					exponent = exponent - 6;
				end else if (fraction[3] == 1'b1) begin
					fraction = fraction << 7;
					exponent = exponent - 7;
				end else if (fraction[2] == 1'b1) begin
					fraction = fraction << 8;
					exponent = exponent - 8;
				end else if (fraction[1] == 1'b1) begin
					fraction = fraction << 9;
					exponent = exponent - 9;
				end else if (fraction[0] == 1'b1) begin
					fraction = fraction << 10;
					exponent = exponent - 10;
				end 
			end
		end
		mantissa = fraction[9:0];
		if(exponent[5]==1'b1) begin //exponent is negative
			sum = 16'b0000000000000000;
		end
		else begin
			sum = {sign,exponent[4:0],mantissa};//�������
		end		
	end		
end

endmodule
