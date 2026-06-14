package br.edu.unoesc.vestock.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Condicional;

public interface CondicionalRepository extends JpaRepository<Condicional, Integer> {
	long countByDevolvidoFalse();

	List<Condicional> findByDataDevolucaoBetweenAndDevolvidoFalse(LocalDateTime inicio, LocalDateTime fim);

	List<Condicional> findByLojaId(Integer lojaId);

	long countByLojaIdAndDevolvidoFalse(Integer lojaId);

	List<Condicional> findByLojaIdAndDataDevolucaoBetweenAndDevolvidoFalse(Integer lojaId, LocalDateTime atStartOfDay,
			LocalDateTime atTime);

}
