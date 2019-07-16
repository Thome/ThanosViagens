-- Liste o Nome de todas as franquias que possuem piscina e restaurante e estacionamento (OK)
SELECT nome FROM franquia
WHERE estacionamento = true AND restaurante = true AND piscina = true;
 
-- Liste o número de franquias de uma hospedaria (OK)
SELECT nome_comercial, count(id_franquia) FROM hospedaria h
JOIN franquia f USING(cnpj)
GROUP BY cnpj;

-- Onde estão localizadas as franquias de uma hospedaria x (OK) 
SELECT f.nome, e.cidade FROM hospedaria h
JOIN franquia f USING(cnpj)
JOIN endereco e USING(id_endereco)
WHERE LOWER(h.nome_comercial) = LOWER('?');

-- Nome e user IDs de todos usuarios que fizeram reserva por essa aplicação.
SELECT nome_completo,id_reserva_quarto FROM usuario 
NATURAL JOIN reserva_quarto ORDER BY nome_completo;

-- Media de avaliação de serviços > 6 (OK)
SELECT nome, avg(servicos) AS Media_servicos FROM franquia f 
JOIN avaliacao_usuario a ON(a.franquia_id = f.id_franquia)
GROUP BY nome 
HAVING avg(servicos) > 6
ORDER BY Media_servicos DESC;

-- Liste as franquias de uma cidade x onde ? é a entrada do usuario (OK)
SELECT f.nome FROM endereco 
JOIN franquia f USING(id_endereco) 
WHERE LOWER(cidade) LIKE LOWER('?');
 
-- Media Geral das Hospedarias (OK)
SELECT nome, ((Media_servicos + Media_acomodacoes)/2) AS Media_geral FROM(
	SELECT nome, avg(servicos) AS Media_servicos, avg(acomodacoes) AS Media_acomodacoes FROM franquia f 
	JOIN avaliacao_usuario a ON(a.franquia_id = f.id_franquia)
	GROUP BY nome 
) AS medias ORDER BY media_geral;

-- Nome dos usuários que fizeram reserva em um tipo de quarto com duas camas ou mais do mesmo tipo (OK)
SELECT nome_completo FROM usuario 
JOIN reserva_quarto USING (cpf) 
WHERE id_tipo_de_quarto IN (SELECT idquarto FROM cama_esta WHERE quant >= 2);

-- Nome dos usuários ques estão hospedado no dia atual em alguma hospedaria onde ? é a data atual (OK)

SELECT u.nome_completo, rq.saida FROM usuario u 
JOIN reserva_quarto rq USING (cpf) 
WHERE rq.entrada <= '?' AND rq.saida >= '?' 
ORDER BY u.nome_completo;

-- Liste os comentários de uma hospedaria, o autor do comentario e o nome da franquia
 
SELECT u.nome_completo, a.comentario, franquia.nome  FROM usuario u 
 JOIN avaliacao_usuario a ON (u.cpf = a.cpf_usuario)
 NATURAL JOIN (
	SELECT nome, comentario FROM avaliacao_usuario a
	JOIN franquia f ON (f.id_franquia = a.franquia_id)
	) AS franquia;


