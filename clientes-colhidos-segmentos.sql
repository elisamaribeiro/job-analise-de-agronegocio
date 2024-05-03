/* 
Consulta SQL para buscar registros de várias tabelas, usando FULL OUTER JOIN para garantir que todos os registros de todas as tabelas sejam incluídos, 
independentemente de haver correspondências entre elas. As condições WHERE restringem os resultados com base nos valores de algumas colunas específicas. 
*/

SELECT 
    vistoria.geracao_demanda.*, 
    vistoria.padrao_geracao_demanda.*, 
    vistoria.vistoria.*,
    vistoria.campo.*,
    vistoria.campo_formulario.*,
    vistoria.etapa_vistoria.*,
    vistoria.formulario.*,
    vistoria.resposta_vistoria.*,
    fms.proprietario.*, 
    fms.fazenda.*, 
    fms.filial.*, 
    fms.regional.*, 
    fms.ctv.*
FROM 
    vistoria.geracao_demanda
FULL OUTER JOIN 
    vistoria.padrao_geracao_demanda ON vistoria.geracao_demanda.id = vistoria.padrao_geracao_demanda.geracao_demanda_id
FULL OUTER JOIN
    vistoria.vistoria ON vistoria.geracao_demanda.vistoria_id = vistoria.vistoria.id
FULL OUTER JOIN
    fms.proprietario ON vistoria.vistoria.proprietario =  fms.proprietario.id_proprietario
FULL OUTER JOIN
    fms.fazenda ON vistoria.vistoria.fazenda = fms.fazenda.id_fazenda
FULL OUTER JOIN
    fms.ctv ON fms.fazenda.id_ctv = fms.ctv.id
FULL OUTER JOIN 
    fms.filial ON fms.ctv.id_filial = fms.filial.id_filial
FULL OUTER JOIN
    fms.regional ON fms.filial.id_regional = fms.regional.id_regional
FULL OUTER JOIN
    vistoria.etapa_vistoria ON vistoria.vistoria.id = vistoria.etapa_vistoria.vistoria_id
FULL OUTER JOIN 
    vistoria.formulario ON vistoria.etapa_vistoria.formulario_id = vistoria.formulario.id
FULL OUTER JOIN
    vistoria.campo_formulario ON vistoria.formulario.id = vistoria.campo_formulario.formulario_id
FULL OUTER JOIN
    vistoria.campo ON vistoria.campo_formulario.campo_id = vistoria.campo.id
FULL OUTER JOIN
    vistoria.resposta_vistoria ON vistoria.etapa_vistoria.id = vistoria.resposta_vistoria.etapa_vistoria_id
WHERE
    vistoria.campo.id = '67'
    AND vistoria.campo_formulario.campo_id = '67'
    AND vistoria.resposta_vistoria.campo_id = '67'
    AND vistoria.geracao_demanda.tipo_avaliacao IN ('SEMENTE_SOJA', 'SEMENTE_MILHO', 'PASTAGEM')
    AND vistoria.formulario.etapa IN ('COLHEITA_A', 'COLHEITA_FAZENDA')
    AND vistoria.padrao_geracao_demanda.tipo_padrao IN ('AGRO', 'FAZENDA')
    AND vistoria.etapa_vistoria.etapa IN ('COLHEITA_A', 'COLHEITA_FAZENDA')
    AND vistoria.etapa_vistoria.status = 'REALIZADA'
    AND vistoria.formulario.cultura IN ('SEMENTE_SOJA', 'SEMENTE_MILHO', 'PASTAGEM');
