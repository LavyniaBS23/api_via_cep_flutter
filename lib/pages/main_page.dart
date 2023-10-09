import 'package:api_via_cep_flutter/models/via_cep_model.dart';
import 'package:api_via_cep_flutter/repositories/ceps_repository.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var cepController = TextEditingController(text: "");
  CepsRepository cepRepository = CepsRepository();
  var _ceps = ViaCepsModel([]);
  var viaCepModel = ViaCepModel.vazio();

  bool loading = false;
  bool jaExiste = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obterCeps();
  }

  obterCeps() async {
    _ceps = await cepRepository.obterCeps();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("CEPS"),
            ),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext bc) {
                        return AlertDialog(
                          title: const Text("Adicionar CEP"),
                          content: Column(
                            children: [
                              const Text("CEP", style: TextStyle(fontSize: 22)),
                              TextField(
                                controller: cepController,
                                keyboardType: TextInputType.number,
                                onChanged: (String value) async {
                                  var cep =
                                      value.replaceAll(RegExp(r'[^0-9]'), '');
                                  if (cep.length == 8) {
                                    setState(() {
                                      loading = true;
                                    });
                                    viaCepModel =
                                        await cepRepository.consultarCep(cep);
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "${viaCepModel.localidade} - ${viaCepModel.uf}",
                                  style: const TextStyle(fontSize: 22))
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancelar")),
                            TextButton(
                                onPressed: () async {
                                  if (viaCepModel.cep != "") {
                                    jaExiste = await cepRepository
                                        .buscaCep(viaCepModel);
                                    if (jaExiste == false) {
                                      cepRepository.criar(viaCepModel);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Endereço Cadastrado")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "O endereço já está cadastrado")));
                                    }
                                  }
                                  Navigator.pop(context);
                                  cepController.text = "";
                                  viaCepModel = ViaCepModel.vazio();
                                  obterCeps();
                                  setState(() {});
                                },
                                child: const Text("Salvar"))
                          ],
                        );
                      });
                }),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _ceps.results.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var cep = _ceps.results[index];
                        return Dismissible(
                          onDismissed:
                              (DismissDirection dismissDirection) async {
                            await cepRepository.remover(cep.objectId);
                            obterCeps();
                          },
                          key: Key(cep.objectId),
                          child: ListTile(
                            title: Text(cep.cep),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
