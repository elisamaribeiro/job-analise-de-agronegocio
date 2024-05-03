SELECT 
    vistoria.geracao_demanda.*, 
    vistoria.padrao_geracao_demanda.*, 
    vistoria.vistoria.*,
    fms.proprietario.*, 
    fms.fazenda.*, 
    fms.filial.*, 
    fms.regional.*, 
    fms.ctv.*
FROM 
    vistoria.geracao_demanda
JOIN 
    vistoria.padrao_geracao_demanda ON vistoria.geracao_demanda.id = vistoria.padrao_geracao_demanda.geracao_demanda_id
JOIN
    vistoria.vistoria ON vistoria.geracao_demanda.vistoria_id = vistoria.vistoria.id
JOIN
    fms.proprietario ON vistoria.vistoria.proprietario =  fms.proprietario.id_proprietario
JOIN
    fms.fazenda ON vistoria.vistoria.fazenda = fms.fazenda.id_fazenda
JOIN
    fms.ctv ON fms.fazenda.id_ctv = fms.ctv.id
JOIN 
    fms.filial ON fms.ctv.id_filial = fms.filial.id_filial
JOIN
    fms.regional ON fms.filial.id_regional = fms.regional.id_regional
WHERE
    vistoria.geracao_demanda.tipo_avaliacao = 'SEMENTE_SOJA'
    AND vistoria.padrao_geracao_demanda.tipo_padrao IN ('AGROAMAZONIA', 'FAZENDA');
