USE [familias]
GO

/****** Object:  View [dbo].[VW_FAMILIA]    Script Date: 27-Jul-20 8:54:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VW_FAMILIA] as
select --*, -- geral.FAMILIA, count(*)
		geral.IBGE+';' [IBGE;],
		geral.ano_cadastro [ANO_CADASTRO;],
		geral.id_familia+';' [ID_FAMILIA;],
		geral.sexo_responsável+';' [SEXO_RESP;],
		coalesce(geral.UF,'Não identificado')+ ';' as [UF;] ,
		coalesce(geral.MUNICIPIO,'Não identificado')+';'  as [MUNICIPIO;],
		COALESCE(geral.MESORREGIAO,'Não identificado')+';' [MESORREGIAO;],
		cast(geral.VL_MED_FAM as varchar)+ ';'  as [VL_MED_FAM;], 
		coalesce(geral.LOCAL_DOM_FAM,'Não identificado')+ ';' as [LOCAL_DOM_FAM;],
		coalesce(geral.ESPEC_DOM_FAM,'Não identificado')+ ';'  as [ESPEC_DOM_FAM;],
		cast(geral.QTD_COMODO_DOMIC_FAM as varchar)+';' as [QTD_COMODO_DOMIC_FAM;] ,
		cast(geral.QTD_DORM_FAM as varchar)+';' as [QTD_DORM_FAM;], 
		coalesce(geral.MAT_PISO_FAMILIA,'Não identificado')+';'  as [MAT_PISO_FAMILIA;],
		coalesce(geral.MATERIA_CONSTRUCAO,'Não identificado')+';'  as [MATERIA_CONSTRUCAO;],
		coalesce(geral.AGUA_ENCANADA,'Não identificado')+';' as [AGUA_ENCANADA;],
		coalesce(geral.ABASTECIMENTO,'Não identificado')+';' as [ABASTECIMENTO;],
		coalesce(geral.TEM_BANHEIRO,'Não identificado')+';' as [TEM_BANHEIRO;],
		coalesce(geral.ESCOAMENTO_SANITARIO,'Não identificado')+';' as [ESCOAMENTO_SANITARIO;],
		coalesce(geral.DESTINO_LIXO,'Não identificado')+';'  as [DESTINO_LIXO;],
		coalesce(geral.ILUMINAcAO,'Não identificado')+';'  as [ILUMINACAO;],
		coalesce(geral.CALCAMENTO,'Não identificado')+';' as [CALCAMENTO;],
		--coalesce(geral.INDIGENA,'Não identificado')+';'  as [INDIGENA;] ,
		--coalesce(geral.QUILOMBOLA,'Não identificado')+';'  as [QUILOMBOLA;],
		CASE WHEN geral.INDIGENA = 'Sim;' then 'Indigena;' 
			 WHEN geral.QUILOMBOLA = 'Sim;' then 'Quilombola;' 
			 --when geral.EXTRATIVISTA >= 1 then 'Extrativista;' 
			 else coalesce(geral.FAMILIA,'Não identificado')+';' end  as [FAMILIA;] ,
		coalesce(geral.CLASSE_CIDADE,'Não identificado')+';'  as [CLASSE_CIDADE;],
		--case when geral.EXTRATIVISTA >= 1 then 'Sim' else 'Não' end +';'  as [EXTRATIVISTA;],
		cast(geral.QTD_PESSOAS as varchar)+';'  as [QTD_PESSOA;],
		cast(geral.QTD_MASC as varchar)+';'  as [QTD_MASC;],
		cast(geral.QTD_FEM as varchar)+';'  as [QTD_FEM;], 
		cast(geral.qt_menor18 as varchar)+';'  as [QTD_MENOR18;],
		coalesce(geral.TEM_DEFICIENTE,'Não identificado')+';'  as [TEM_DEFICIENTE;],
		coalesce(geral.TEM_ANALFABETO,'Não identificado')+';' as [TEM_ANALFABETO;],
		(select top 1 Ensino from Estudo e with(nolock) where e.["id_familia"] = geral.id_familia order by 1 asc )		
		[MAI_ENSINO;],
		coalesce(geral.ENSINO_SUPERIOR,'Não identificado')+';'  as [ENSINO_SUPERIOR;],
		coalesce(geral.MENOR_ESTUDA,'Não identificado')+';'  as [MENOR_ESTUDA;],
		cast(geral.RENDAS_PROV_TRAB_REG as varchar)+';' as [RENDA_PROV_TRAB_REG;], 
		cast(geral.RENDAS_12MESES_REG as varchar)+';'  as [RENDA_12MESES_REG;],
		cast(geral.RENDA_APOSENTADORIA as varchar)+';'  as [RENDA_APOSENTADORIA;],
		cast(geral.RENDAS_DIVERSAS as varchar)+';'  as [RENDAS_DIVERSAS;],
		cast(geral.PERIODO_MAX_TRAB_MEMB as varchar)+';'  as [PERIODO_MAX_TRAB_MEMB;],
		cast(geral.vl_menor as varchar)+';' [VL_MENOR;],
		cast((geral.soma/
		geral.count_) as varchar) + ';'  [MEDIA_IDADE;],
		cast(geral.TM_BF as varchar) as TM_BF
from	
			(select --distinct 
			--top 100000
			substring(a.["dat_cadastramento_fam"],1,4)+';' ano_cadastro,
			--coalesce(iif(b.["cod_parentesco_rf_pessoa"] = 1 and b.["cod_sexo_pessoa"] = 1, 'M','F'),'Nulo') sexo_responsável, 
			(select iif(x.["cod_sexo_pessoa"] = 1, 'M','F') from [base_amostra_pessoa_201812] x where x.["id_familia"]  = a.["id_familia"] and x.["cod_parentesco_rf_pessoa"] = 1 ) sexo_responsável,
			a.["id_familia"] idFamilia,
			c.[Nome_UF] UF,
			c.[Código Município Completo] IBGE,
			c.[Nome_Município] MUNICIPIO,
			c.[Nome_Mesorregião] MESORREGIAO,
			a.["vlr_renda_media_fam"]	 as VL_MED_FAM,
			case ["cod_local_domic_fam"] when 1 then 'Urbana' else 'Rural' end LOCAL_DOM_FAM,
			case ["cod_especie_domic_fam"] when 1 then 'Particular Permanente' when 2 then 'Particular Improvisado' else 'Coletivo' end ESPEC_DOM_FAM,
			["qtd_comodos_domic_fam"] QTD_COMODO_DOMIC_FAM,
			["qtd_comodos_dormitorio_fam"] QTD_DORM_FAM, 
			case ["cod_material_piso_fam"] when 1 then 'Terra' when 2 then 'Cimento' when 3 then 'Madeira Aproveitada' 
										   when 4 then 'Madeira Aparelhada' when 5 then 'Ceramica, Lajota, Pedra' when 6 then 'carpete' 
										   else 'Outro Material' end MAT_PISO_FAMILIA,  
			case ["cod_material_domic_fam"] when 1 then 'Alvenaria / Tijolo com Revestimento' when 2 then 'Alvenaria / Tijolo sem Revestimento' when 3 then 'Madeira Aparelhada' 
										   when 4 then 'Taipa Revestida' when 5 then 'Taipa Não Revestida' when 6 then 'Madeira Aproveitada' 
										   when 7 then 'Palha' 
										   else 'Outro Material' end MATERIA_CONSTRUCAO, 
			case ["cod_agua_canalizada_fam"] when 1 then 'Sim' else 'Nao' end AGUA_ENCANADA,
			case ["cod_abaste_agua_domic_fam"]  when 1 then  'Rede geral de distribuição'
												when 2 then 'Poço ou nascente'
												when 3 then 'Cisterna'
												when 4 then 'Outra forma' end ABASTECIMENTO,
			case ["cod_banheiro_domic_fam"] when 1 then 'Sim' else 'Nao' end TEM_BANHEIRO,
			case ["cod_escoa_sanitario_domic_fam"]	when 1 then 'Rede coletora de esgoto ou pluvial'
													when 2 then 'Fossa séptica'
													when 3 then 'Fossa rudimentar'
													when 4 then 'Vala a céu aberto'
													when 5 then 'Direto para um rio, lago ou mar'
													when 6 then 'Outra forma' end ESCOAMENTO_SANITARIO,

			case ["cod_destino_lixo_domic_fam"]		when 1 then 'É coletado diretamente'
													when 2 then 'É coletado indiretamente'
													when 3 then 'É queimado ou enterrado na propriedade'
													when 4 then 'É jogado em terreno baldio ou logradouro (rua, avenida, etc.)'
													when 5 then 'É jogado em rio ou mar'
													when 6 then 'Tem outro destino' end DESTINO_LIXO,
			case  ["cod_iluminacao_domic_fam"]	when 1 then 'Elétrica com medidor próprio'
												when 2 then 'Elétrica com medidor comunitário'
												when 3 then 'Elétrica sem medidor'
												when 4 then 'Óleo, querosene ou gás'
												when 5 then 'Vela'
												when 6 then 'Outra forma' end ILUMINACAO,
			case ["cod_calcamento_domic_fam"] when 1 then 'Total' when 2 then 'Parcial' else 'Nenhum' end CALCAMENTO,
			case ["cod_familia_indigena_fam"] when 1 then 'Sim' else 'Nao' end INDIGENA,
			case ["ind_familia_quilombola_fam"] when 1 then 'Sim' else 'Nao' end QUILOMBOLA, 
			--["nom_estab_assist_saude_fam"]
			--["cod_eas_fam"]
			--["nom_centro_assist_fam"]
			--["cod_centro_assist_fam"]
			case ["ind_parc_mds_fam"]	when 101 then  'Família Cigana'
										when 201  then 'Família Extrativista'
										when 202 then  'Família de Pescadores Artesanais'
										when 203  then 'Família pertencente a Comunidade de Terreiro'
										when 204 then  'Família Ribeirinha'
										when 205 then  'Família de Agricultores Familiares'
										when 301 then  'Família Assentada da Reforma Agrária'
										when 302 then  'Família beneficiária do Programa Nacional de Crédito Fundiário'
										when 303 then  'Família Acampada'
										when 304 then  'Família Atingida por Empreendimentos de Infraestrutura'
										when 305 then  'Família de Preso do Sistema Carcerário'
										when 306 then  'Família de Catadores de Material Reciclável'
										when 000 then  'Nenhuma' end  FAMILIA,

			--["peso.fam"],
			--a.["id_familia"],
			--["estrato"],
			case a.["classf"] when 1 then 'Capital' when 2 then 'Região Metropolitana' else 'Outros' end CLASSE_CIDADE,
			/**************************************
			**************************************
			Compilado da Pessoa
			**************************************
			**************************************/ 

			--count(iif(b.["cod_agricultura_trab_memb"] >= 1,1, null )) EXTRATIVISTA,
			(select count(*) from [base_amostra_pessoa_201812] x where x.["id_familia"]  = a.["id_familia"] and  x.["cod_agricultura_trab_memb"] >= 1 ) EXTRATIVISTA,
			["qtde_pessoas"] as QTD_PESSOAS,
			count(iif(b.["cod_sexo_pessoa"] = 1,1, null )) as QTD_MASC,
			count(iif(b.["cod_sexo_pessoa"] = 2,1, null )) as QTD_FEM,
			count(iif(b.["idade"] < 18 ,1, null )) as qt_menor18, /* esta trazendo errado */
			case when count(iif(b.["cod_deficiencia_memb"] = 1 ,1,null)) >= 1 then 'S' else 'N' end TEM_DEFICIENTE,
			case when count(iif(b.["cod_sabe_ler_escrever_memb"] = 1 and  b.["idade"] > 18 ,1,null)) >= 1 then 'S' else 'N' end TEM_ANALFABETO,
			case when count(iif(b.["cod_curso_frequenta_memb"] = 13 and b.["cod_concluiu_frequentou_memb"] = 1 ,1,null)) >= 1 then 'S' else 'N' end ENSINO_SUPERIOR,
			/*ver melhor*/
			case 
				 when count(iif(b.["idade"] between 6 and 17 and b.["ind_frequenta_escola_memb"] in (1,2) ,1,null)) = count(iif(b.["idade"] between 5 and 17 ,1, null )) and count(iif(b.["idade"] between 5 and 17 ,1, null )) > 0 then 'Todos Menores Estudam' 
				 when count(iif(b.["idade"] between 6 and 17 and b.["ind_frequenta_escola_memb"] in (3,4) ,1,null)) = count(iif(b.["idade"] between 5 and 17 ,1, null )) and count(iif(b.["idade"] between 5 and 17 ,1, null )) > 0 then 'Todos Menores Não Estudam' 
				 when count(iif(b.["idade"] between 6 and 17  and b.["ind_frequenta_escola_memb"] in (3,4) ,1,null)) >= 1 then 'Existe menores que não estuda'
				 when count(iif(b.["idade"] between 0 and 5  and b.["ind_frequenta_escola_memb"] in (3,4) ,1,null)) >= 1 then 'Menor sem idade escolar'
				 else 'Não tem Menor' 
				 end MENOR_ESTUDA,
			sum(cast(b.["val_remuner_emprego_memb"] as integer))+	
			sum(cast(b.["val_renda_seguro_desemp_memb"] as integer)) RENDAS_PROV_TRAB_REG,	
			sum(cast(b.["val_renda_bruta_12_meses_memb"] as integer)) RENDAS_12MESES_REG,
			sum(cast(b.["val_renda_aposent_memb"] as integer)) RENDA_APOSENTADORIA,
			sum(cast(b.["val_renda_doacao_memb"] as integer)) +
			sum(cast(b.["val_renda_pensao_alimen_memb"] as integer)) + 
			sum(cast(b.["val_outras_rendas_memb"] as integer))  as RENDAS_DIVERSAS ,
			max(b.["qtd_meses_12_meses_memb"]  ) as PERIODO_MAX_TRAB_MEMB,

			/*trabalho infantil*/ 
			sum(iif(b.["idade"] between 6 and 15,cast(b.["val_outras_rendas_memb"] as integer) + cast(b.["val_remuner_emprego_memb"] as integer) + cast(b.["val_renda_bruta_12_meses_memb"] as integer) + cast(b.["val_renda_doacao_memb"] as integer) , 0)) as 
			vl_menor,
			--b.["cod_sexo_pessoa"],
			sum(cast(b.["idade"] as integer))  soma,
			count(*) count_, 
			a.["id_familia"] id_familia, 
			["marc_pbf"] TM_BF
			 --b.*
			from --ffamilia 
					base_amostra_familia_201812 a  --inner join [base_amostra_pessoa_201812_1] b WITH (NOLOCK)
					inner join base_amostra_pessoa_201812 b WITH (NOLOCK)
				on a.["id_familia"] = b.["id_familia"] 
					inner join municipio c WITH (NOLOCK)
				on a.["cd_ibge"] = [Código Município Completo]
			--where b.["id_familia"] = '11749' -- and b.["id_familia"] = 4
			and  substring(a.["dat_cadastramento_fam"],1,4) =
	  (
	  iif(substring(a.["dat_alteracao_fam"],1,4) > substring(a.["dat_atualizacao_familia"],1,4)
	  ,substring(a.["dat_alteracao_fam"],1,4),substring(a.["dat_atualizacao_familia"],1,4)
	  )) and substring(a.["dat_alteracao_fam"],1,4) = substring(a.["dat_atualizacao_familia"],1,4)
			group by
				--b.["idade"],
				c.[Código Município Completo],
				c.[Nome_UF],
				c.[Nome_Município],
				c.[Nome_Mesorregião],
				--a.["cd_ibge"],
				a.["vlr_renda_media_fam"],
				a.["cod_local_domic_fam"],
				a.["cod_escoa_sanitario_domic_fam"],
				a.["cod_especie_domic_fam"],
				a.["qtde_pessoas"],
				a.["qtd_comodos_domic_fam"],
				a.["qtd_comodos_dormitorio_fam"],
				a.["cod_material_piso_fam"],
				a.["cod_material_domic_fam"],
				a.["cod_agua_canalizada_fam"],
				a.["cod_abaste_agua_domic_fam"],
				a.["cod_banheiro_domic_fam"],
				a.["cod_destino_lixo_domic_fam"],
				a.["cod_iluminacao_domic_fam"],
				a.["cod_calcamento_domic_fam"],
				a.["cod_familia_indigena_fam"],
				a.["ind_familia_quilombola_fam"],
				a.["ind_parc_mds_fam"],
				a.["classf"],
				a.["marc_pbf"],
				--b.["cod_sexo_pessoa"],
				a.["id_familia"]--,
				--b.["cod_parentesco_rf_pessoa"]--,
				--b.["cod_sexo_pessoa"],
				,a.["dat_cadastramento_fam"]
			--order by 2 asc
			) geral 
where 
	 geral.ano_cadastro = '2018;' and 
	--geral.UF in ('Alagoas') --and 
	 substring(geral.IBGE,1,1) = '2'
	 -- '2' Nordeste 
	--geral.MUNICIPIO = ('São Paulo')
	--geral.MESORREGIAO = 'Metropolitana de São Paulo'
	--and geral.TM_BF = 1 and
	--(geral.MENOR_ESTUDA in ('Todos Menores Não Estudam','Existe menores que não estuda')
	--or geral.vl_menor > 0 
	--or geral.VL_MED_FAM > 965)--and geral.MUNICIPIO in ('São Paulo') and geral.ESPEC_DOM_FAM = 'Coletivo'
--order by geral.RENDAS_12MESES_REG asc
	--and geral.FAMILIA <> 'Nenhuma'
	-- and (geral.INDIGENA = 'Sim' or geral.QUILOMBOLA = 'Sim')
--ORDER BY geral.RENDAS_PROV_TRAB_REG desc
--where geral.meno_estuda = 'Não tem Menor'  and geral.qt_menor18 > 0 
--group by geral.FAMILIA 
GO

