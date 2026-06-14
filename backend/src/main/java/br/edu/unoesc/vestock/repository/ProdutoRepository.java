package br.edu.unoesc.vestock.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import br.edu.unoesc.vestock.model.Produto;

public interface ProdutoRepository extends JpaRepository<Produto, Integer> {
	List<Produto> findByLojaId(Integer lojaId);

	long countByLojaId(Integer lojaId);

	List<Produto> findByLojaIdAndQuantidadeEstoqueGreaterThan(Integer lojaId, int quantidadeEstoque);

	long countByLojaIdAndQuantidadeEstoqueGreaterThan(Integer lojaId, int quantidadeEstoque);

	List<Produto> findByLojaIdAndQuantidadeEstoqueLessThanEqual(Integer lojaId, int quantidadeEstoque);

	@Query("SELECT p FROM Produto p WHERE p.loja.id = :lojaId AND (" +
			"LOWER(p.nome) LIKE LOWER(CONCAT('%', :termo, '%')) OR " +
			"LOWER(p.tipo) LIKE LOWER(CONCAT('%', :termo, '%')) OR " +
			"LOWER(p.cor) LIKE LOWER(CONCAT('%', :termo, '%')) OR " +
			"LOWER(p.tamanho) LIKE LOWER(CONCAT('%', :termo, '%')))")
	List<Produto> buscarPorTermo(@Param("lojaId") Integer lojaId, @Param("termo") String termo);
}
