package br.edu.unoesc.vestock.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import br.edu.unoesc.vestock.model.Desconto;

public interface DescontoRepository extends JpaRepository<Desconto, Integer> {

}
