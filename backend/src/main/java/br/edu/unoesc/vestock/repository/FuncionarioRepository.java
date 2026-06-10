package br.edu.unoesc.vestock.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Funcionario;

public interface FuncionarioRepository extends JpaRepository<Funcionario, Integer> {

}
