package br.edu.unoesc.vestock.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Funcionario;
import br.edu.unoesc.vestock.model.Loja;

public interface FuncionarioRepository extends JpaRepository<Funcionario, Integer> {

	List<Funcionario> findByLoja(Loja loja);

	Long countByLoja(Loja loja);

	List<Funcionario> findByLojaId(Integer lojaId);

}