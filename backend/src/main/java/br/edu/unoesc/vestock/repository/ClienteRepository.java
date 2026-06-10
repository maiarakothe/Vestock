package br.edu.unoesc.vestock.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import br.edu.unoesc.vestock.model.Cliente;

public interface ClienteRepository extends JpaRepository<Cliente, Integer> {

	@Query("SELECT c FROM Cliente c WHERE LOWER(c.nome) LIKE LOWER(CONCAT('%', :termo, '%')) "
			+ "OR LOWER(c.email) LIKE LOWER(CONCAT('%', :termo, '%'))")
	List<Cliente> buscarPorNomeOuEmail(@Param("termo") String termo);
}
