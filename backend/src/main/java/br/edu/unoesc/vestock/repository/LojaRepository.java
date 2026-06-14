package br.edu.unoesc.vestock.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import br.edu.unoesc.vestock.model.Loja;

public interface LojaRepository extends JpaRepository<Loja, Integer> {

    Optional<Loja> findByEmail(String email);

   

}