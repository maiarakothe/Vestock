package br.edu.unoesc.vestock.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

/**
 * Representa uma transação de venda.
 */
@Entity
@Table(name = "venda")
public class Venda {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "codven")
	private Integer id;

	/** Data e hora da venda. */
	@Column(name = "datven", nullable = false)
	private LocalDateTime dataVenda;

	/** Valor total da venda. */
	@Column(name = "totven", precision = 10, scale = 2, nullable = false)
	private BigDecimal totalVenda;

	/** Forma de pagamento. */
	@Column(name = "fompagven", length = 50, nullable = false)
	private String formaPagamento;

	/** Valor de desconto por cupom. */
	@Column(name = "cupdscven", precision = 10, scale = 2)
	private BigDecimal valorCupomDesconto;

	/** Cliente que realizou a compra. */
	@ManyToOne
	@JoinColumn(name = "codcli", nullable = false)
	private Cliente cliente;

	/** Funcionário que realizou a venda. */
	@ManyToOne
	@JoinColumn(name = "codfun", nullable = false)
	private Funcionario funcionario;

	@ManyToOne
	@JoinColumn(name = "coddsc")
	private Desconto desconto;

	@OneToMany(mappedBy = "venda", cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonManagedReference
	private List<ItemVenda> itens = new ArrayList<>();

	public Venda() {

	}

	public Venda(Integer id, LocalDateTime dataVenda, BigDecimal totalVenda, String formaPagamento,
			BigDecimal valorCupomDesconto, Cliente cliente, Funcionario funcionario, Desconto desconto,
			List<ItemVenda> itens) {
		super();
		this.id = id;
		this.dataVenda = dataVenda;
		this.totalVenda = totalVenda;
		this.formaPagamento = formaPagamento;
		this.valorCupomDesconto = valorCupomDesconto;
		this.cliente = cliente;
		this.funcionario = funcionario;
		this.desconto = desconto;
		this.itens = itens;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public LocalDateTime getDataVenda() {
		return dataVenda;
	}

	public void setDataVenda(LocalDateTime dataVenda) {
		this.dataVenda = dataVenda;
	}

	public BigDecimal getTotalVenda() {
		return totalVenda;
	}

	public void setTotalVenda(BigDecimal totalVenda) {
		this.totalVenda = totalVenda;
	}

	public String getFormaPagamento() {
		return formaPagamento;
	}

	public void setFormaPagamento(String formaPagamento) {
		this.formaPagamento = formaPagamento;
	}

	public BigDecimal getValorCupomDesconto() {
		return valorCupomDesconto;
	}

	public void setValorCupomDesconto(BigDecimal valorCupomDesconto) {
		this.valorCupomDesconto = valorCupomDesconto;
	}

	public Cliente getCliente() {
		return cliente;
	}

	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
	}

	public Funcionario getFuncionario() {
		return funcionario;
	}

	public void setFuncionario(Funcionario funcionario) {
		this.funcionario = funcionario;
	}

	public Desconto getDesconto() {
		return desconto;
	}

	public void setDesconto(Desconto desconto) {
		this.desconto = desconto;
	}

	public List<ItemVenda> getItens() {
		return itens;
	}

	public void setItens(List<ItemVenda> itens) {
		this.itens = itens;
	}

	/** Adiciona um item à lista */
	public void addItemVenda(ItemVenda item) {
		this.itens.add(item);
		item.setVenda(this);
	}

}
