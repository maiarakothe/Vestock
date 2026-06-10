package br.edu.unoesc.vestock.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Representa uma opção de desconto.
 */
@Entity
@Table(name = "desconto")
public class Desconto {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "coddsc")
	private Integer id;

	/** Nome ou código do desconto. */
	@Column(name = "nomdsc", length = 50, nullable = false)
	private String nome;

	/** Valor ou percentual do desconto. */
	@Column(name = "valdsc", precision = 10, scale = 2, nullable = false)
	private BigDecimal valor;

	/** Data de cadastro. */
	@Column(name = "caddsc")
	private LocalDateTime dataCadastro;

	/** Data de validade. */
	@Column(name = "vlddsc")
	private LocalDate dataValidade;

	/** Venda na qual o desconto foi aplicado */
	@ManyToOne
	@JoinColumn(name = "codven", nullable = true)
	private Venda venda;

	// Getters e Setters

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public BigDecimal getValor() {
		return valor;
	}

	public void setValor(BigDecimal valor) {
		this.valor = valor;
	}

	public LocalDateTime getDataCadastro() {
		return dataCadastro;
	}

	public void setDataCadastro(LocalDateTime dataCadastro) {
		this.dataCadastro = dataCadastro;
	}

	public LocalDate getDataValidade() {
		return dataValidade;
	}

	public void setDataValidade(LocalDate dataValidade) {
		this.dataValidade = dataValidade;
	}

	public Venda getVenda() {
		return venda;
	}

	public void setVenda(Venda venda) {
		this.venda = venda;
	}
}
