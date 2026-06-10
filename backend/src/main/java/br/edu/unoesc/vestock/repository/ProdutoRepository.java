package br.edu.unoesc.vestock.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Produto;

public interface ProdutoRepository extends JpaRepository<Produto, Integer> {
	List<Produto> findByQuantidadeEstoqueGreaterThan(int quantidadeEstoque);

	List<Produto> findByQuantidadeEstoqueLessThanEqual(int quantidadeEstoque);

	long countByQuantidadeEstoqueGreaterThan(int quantidadeEstoque);

	List<Produto> findByNomeContainingIgnoreCaseOrTipoContainingIgnoreCaseOrCorContainingIgnoreCaseOrTamanhoContainingIgnoreCase(
			String nome, String tipo, String cor, String tamanho);
}
