package br.edu.unoesc.vestock.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Pessoa;

public interface PessoaRepository extends JpaRepository<Pessoa, Integer> {

}
