import 'package:flutter/material.dart';

class LivroLido {
  final String nome;
  int avaliacao;

  LivroLido(this.nome, {this.avaliacao = 0});
}

class LivroLendo {
  final String nome;
  int paginaAtual;

  LivroLendo(this.nome, {this.paginaAtual = 1});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final List<LivroLido> _livrosLidos = [];
  final List<LivroLendo> _livrosLendo = [];
  final List<String> _livrosDesejados = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _paginaController = TextEditingController();

  late TabController _tabController;
  int _abaAtual = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _abaAtual = _tabController.index;
      });
    });
  }

  void _adicionarLivro(String nomeLivro) {
    if (nomeLivro.trim().isEmpty) return;

    setState(() {
      if (_abaAtual == 0) {
        _livrosLidos.add(LivroLido(nomeLivro.trim()));
      } else if (_abaAtual == 1) {
        _livrosLendo.add(LivroLendo(nomeLivro.trim()));
      } else {
        _livrosDesejados.add(nomeLivro.trim());
      }
    });

    _controller.clear();
    Navigator.pop(context);
  }

  void _removerLivro(int index) {
    setState(() {
      if (_abaAtual == 0) {
        _livrosLidos.removeAt(index);
      } else if (_abaAtual == 1) {
        _livrosLendo.removeAt(index);
      } else {
        _livrosDesejados.removeAt(index);
      }
    });
  }

  void _avaliarLivro(int index, int nota) {
    setState(() {
      _livrosLidos[index].avaliacao = nota;
    });
  }

  void _atualizarPagina(LivroLendo livro) {
    _paginaController.text = livro.paginaAtual.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Atualizar página de "${livro.nome}"'),
        content: TextField(
          controller: _paginaController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Página atual'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final novaPagina =
                    int.tryParse(_paginaController.text) ?? livro.paginaAtual;
                livro.paginaAtual = novaPagina;
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Widget _construirListaLidos() {
    if (_livrosLidos.isEmpty) {
      return const Center(child: Text('Nenhum livro lido ainda.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _livrosLidos.length,
      itemBuilder: (context, index) {
        final livro = _livrosLidos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.book, color: Colors.deepPurple),
            title: Text(livro.nome),
            subtitle: Row(
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(
                    i < livro.avaliacao ? Icons.star : Icons.star_border,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  onPressed: () => _avaliarLivro(index, i + 1),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removerLivro(index),
            ),
          ),
        );
      },
    );
  }

  Widget _construirListaLendo() {
    if (_livrosLendo.isEmpty) {
      return const Center(child: Text('Nenhum livro em leitura no momento.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _livrosLendo.length,
      itemBuilder: (context, index) {
        final livro = _livrosLendo[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.auto_stories, color: Colors.deepPurple),
            title: Text(livro.nome),
            subtitle: Text('Página: ${livro.paginaAtual}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  tooltip: 'Atualizar página',
                  onPressed: () => _atualizarPagina(livro),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.green),
                  tooltip: 'Marcar como lido',
                  onPressed: () {
                    setState(() {
                      _livrosLidos.add(LivroLido(livro.nome));
                      _livrosLendo.removeAt(index);
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Remover',
                  onPressed: () => _removerLivro(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _construirListaDesejados() {
    if (_livrosDesejados.isEmpty) {
      return const Center(child: Text('Nenhum livro adicionado ainda.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _livrosDesejados.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ListTile(
          leading: const Icon(Icons.book_outlined, color: Colors.deepPurple),
          title: Text(_livrosDesejados[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.menu_book_rounded, color: Colors.blue),
                tooltip: 'Começar leitura',
                onPressed: () {
                  setState(() {
                    _livrosLendo.add(LivroLendo(_livrosDesejados[index]));
                    _livrosDesejados.removeAt(index);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Remover',
                onPressed: () => _removerLivro(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _abrirDialogoAdicionarLivro() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _abaAtual == 0
              ? 'Adicionar livro lido'
              : _abaAtual == 1
                  ? 'Adicionar livro em leitura'
                  : 'Adicionar livro desejado',
        ),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Nome do livro'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _adicionarLivro(_controller.text),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Livros'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '📚 Lidos'),
            Tab(text: '📖 Lendo'),
            Tab(text: '⭐ Interesse'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _construirListaLidos(),
          _construirListaLendo(),
          _construirListaDesejados(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirDialogoAdicionarLivro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
