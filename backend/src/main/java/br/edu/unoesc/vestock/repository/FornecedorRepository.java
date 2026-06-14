package br.edu.unoesc.vestock.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Fornecedor;

public interface FornecedorRepository extends JpaRepository<Fornecedor, Integer> {

	List<Fornecedor> findByLojaId(Integer lojaId);

}
