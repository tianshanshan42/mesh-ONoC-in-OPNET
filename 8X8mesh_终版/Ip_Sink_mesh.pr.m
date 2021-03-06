MIL_3_Tfile_Hdr_ 145A 140A modeler 9 4C5FC5C3 559A3F6C D CN13549845642 Administrator 0 0 none none 0 0 none C378B63A 1DB9 0 0 0 0 0 0 1bcc 1                                                                                                                                                                                                                                                                                                                                                                                    ��g�      @   D   H      �  d  h  l  �  �  �  �  �           	   begsim intrpt             ����      doc file            	nd_module      endsim intrpt             ����      failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����             Objid	\surr_mod_objid;       Objid	\surr_node_objid;       int	\END_PER;       double	\Offered_load;       Stathandle	\ete_gsh;       double	\ETE_Delay;       double	\modulator_loss;       double	\modulator_pow;       double	\modulator_rate;       double	\detector_pow;       double	\detector_sen;       double	\detector_loss;       double	\OP_length;       double	\detector_rate;          Packet*		pkptr;   /* ����ͳ�Ʊ��� */       'double Power_Disspation_Electronic = 0;   #double Power_Disspation_Optic  = 0;   double Loss_Optic = 0;       int    Hop_Optic = 0;   /       #include "opnet.h"   #include "math.h"   #include <stdio.h>           /*����״̬ת������*/   :#define  ARRIVAL     (op_intrpt_type() == OPC_INTRPT_STRM)   <#define  END_SIM     (op_intrpt_type() == OPC_INTRPT_ENDSIM)               /*���岻ͬ����ı��*/   #define PATHSETUP_FLAG        0   #define OPTICAL_FLAG          1   #define ACK_FLAG              2           /*���������*/   #define ID_NO				  0	             #define DEST_ADDR_FIELD_X     1   #define DEST_ADDR_FIELD_Y     2   #define DEST_ADDR_FIELD_Z     3   #define SOUR_ADDR_FIELD_X	  4   #define SOUR_ADDR_FIELD_Y	  5   #define SOUR_ADDR_FIELD_Z	  6           /*  �����ӵİ�����  */   ;#define ELEC_POWER_FIELD              7                       ;#define OPT_POWER_FIELD               8                       :#define OPT_LOSS_FIELD                9                      -#define HOP_FIELD                     10            /*����ͳ�Ʊ���*/   double   total_ete_delay = 0;   long int rvd_pkts = 0;       double Max_Loss_Optic = 0;   long int  Max_Hop_Optic = 0;   -double Total_Power_Disspation_Electronic = 0;   )double Total_Power_Disspation_Optic  = 0;   double Total_Loss_Optic = 0;           /*��������*/   static void record_stats();      /*��ͳ����д������ļ�*/   void   record_stats()	     	{   	FIN(record_stats());   I	op_stat_scalar_write("ETE Delay(ns)", (double)total_ete_delay/rvd_pkts);   7	op_stat_scalar_write("kgc Packet Received", rvd_pkts);   4	op_stat_scalar_write("Offered Load", Offered_load);   k	op_stat_scalar_write("Average electronic disspation", (double)Total_Power_Disspation_Electronic/rvd_pkts);   i	op_stat_scalar_write("Average optic disspation",      (double)Total_Power_Disspation_Optic/rvd_pkts);      Z	op_stat_scalar_write("Avetage optic loss",            (double)Total_Loss_Optic/rvd_pkts);   O	op_stat_scalar_write("Max optic loss",                (double)Max_Loss_Optic);   K	op_stat_scalar_write("Max hop",                       (int)Max_Hop_Optic);   	   '	printf("�յ��İ�������%d\n",rvd_pkts);   <	printf("ETE Delay��%f\n",(double)total_ete_delay/rvd_pkts);   	FOUT;   	}                                          �   �          
   init   
       
      /* �õ�ģ��Ķ���ID*/   surr_mod_objid = op_id_self();   /* �õ��ڵ�Ķ���ID  */   1surr_node_objid = op_topo_parent(surr_mod_objid);       ?op_ima_obj_attr_get(surr_node_objid, "Collect_Flag", &END_PER);               ;/*    �õ�IP���ܺĵ���ز�����Modelator  �� Detector  �� */       Uop_ima_obj_attr_get(surr_node_objid, "Modulator_Insertion_Loss(dB)",&modulator_loss);   Top_ima_obj_attr_get(surr_node_objid, "Modulator_Power(J/bit)",      &modulator_pow);   Uop_ima_obj_attr_get(surr_node_objid, "Modulator_Rate(Gbps)",        &modulator_rate);   Sop_ima_obj_attr_get(surr_node_objid, "Detector_Power(J/bit)",       &detector_pow);   Sop_ima_obj_attr_get(surr_node_objid, "Detector_Sensitivity(dBm)",   &detector_sen);   Top_ima_obj_attr_get(surr_node_objid, "Detector_Loss(dB)",           &detector_loss);   Lop_ima_obj_attr_get(surr_node_objid, "Detector_Rate(Gbps)", &detector_rate);               Cop_ima_sim_attr_get(OPC_IMA_DOUBLE, "Offered Load", &Offered_load);   Top_ima_sim_attr_get(OPC_IMA_DOUBLE, "Optical Fixed Packet Length(bit)", &OP_length);           
                     
   ����   
          pr_state        J   �          
   idle   
                                       ����             pr_state        �   �          
   
pk_destroy   
       J   &   "/*����Ϣ�������ͳ�ƣ�����¼����*/   %pkptr = op_pk_get(op_intrpt_strm());        1if (op_pk_encap_flag_is_set(pkptr, OPTICAL_FLAG))   	{   F	 op_pk_fd_get(pkptr, ELEC_POWER_FIELD, &Power_Disspation_Electronic);   A	 op_pk_fd_get(pkptr, OPT_POWER_FIELD,  &Power_Disspation_Optic);   3	 op_pk_fd_get(pkptr, OPT_LOSS_FIELD, &Loss_Optic);   ;	 Loss_Optic = Loss_Optic + modulator_loss + detector_loss;   l     Power_Disspation_Optic = Power_Disspation_Optic + modulator_pow * OP_length + detector_pow * OP_length;       -	 op_pk_fd_get(pkptr, HOP_FIELD, &Hop_Optic);       C	 Total_Power_Disspation_Electronic += Power_Disspation_Electronic;   9	 Total_Power_Disspation_Optic += Power_Disspation_Optic;   !	 Total_Loss_Optic += Loss_Optic;   5	 if (Max_Loss_Optic < Loss_Optic)	  /*��������*/	    
         {    		  Max_Loss_Optic = Loss_Optic;   		  }   	 if(Max_Hop_Optic < Hop_Optic)   	    	     {   		  Max_Hop_Optic = Hop_Optic;   		     		  }                        		   	         k	     total_ete_delay += op_sim_time() - op_pk_creation_time_get(pkptr) + OP_length/detector_rate;// 81.92    	   	     rvd_pkts++;       	}               /*���������Ϣ����*/   op_pk_destroy (pkptr);   J                     
   ����   
          pr_state        J            
   stati_collect   
       
      if (END_PER == 1)   	record_stats();   
                         ����             pr_state                        �   �      �   �  L   �          
   tr_0   
       ����          ����          
    ����   
          ����                       pr_transition              �   u     J   �  �   �          
   tr_3   
       
   ARRIVAL   
       ����          
    ����   
          ����                       pr_transition              �   �         �  N   �          
   tr_4   
       ����          ����          
    ����   
          ����                       pr_transition              l   �     J   �  J            
   tr_5   
       
   END_SIM   
       ����          
    ����   
          ����                       pr_transition              P   G     >   �  !   Z  �   Y  Y   �          
   tr_6   
       
   default   
       ����          
    ����   
          ����                       pr_transition                       	ETE Delay        ������������        ԲI�%��}                        