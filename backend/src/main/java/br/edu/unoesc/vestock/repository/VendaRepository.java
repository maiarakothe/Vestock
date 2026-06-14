package br.edu.unoesc.vestock.repository;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import br.edu.unoesc.vestock.model.Venda;

public interface VendaRepository extends JpaRepository<Venda, Integer> {

	@Query(value = "SELECT venda_desconto(:total, :desconto)", nativeQuery = true)
	BigDecimal aplicarDesconto(@Param("total") BigDecimal total,
			@Param("desconto") BigDecimal desconto);

	List<Venda> findByLojaId(Integer lojaId);
}
