/*
 * MOCKUP APPIAN - GESTIONE ALERT L5 (Sospetta Contraffazione)
 * Sistema MAH - Monitoraggio e Gestione Case Alert Critici
 * Direttiva 2011/62/UE - Regolamento Delegato (UE) 2016/161
 */

a!localVariables(
  /* ===== DATI CASE ALERT L5 ===== */
  local!caseAlerts: {
    a!map(
      idCase: "CASE-2024-00156",
      idAlert: "ALT-2024-001234",
      prodotto: "Farmaco ABC 500mg",
      gtin: "08012345678901",
      seriale: "SN2024XYZ789012",
      lotto: "LOT2024-099",
      dataScadenza: date(2026, 12, 31),
      dataGenerazione: today() - 1,
      stato: "APERTO",
      livelloRischio: "ALTO",
      probabilitaContraffazione: 85,
      origineAlert: "NMVS",
      caseManager: "Mario Rossi",
      caseManagerAssegnato: true,
      farmacia: "Farmacia Centrale - Roma",
      mah: "Pharma Company S.p.A."
    ),
    a!map(
      idCase: "CASE-2024-00155",
      idAlert: "ALT-2024-001230",
      prodotto: "Medicinale XYZ 100mg",
      gtin: "08098765432101",
      seriale: "SN2024ABC456789",
      lotto: "LOT2024-088",
      dataScadenza: date(2025, 6, 30),
      dataGenerazione: today() - 2,
      stato: "IN_ANALISI",
      livelloRischio: "MOLTO_ALTO",
      probabilitaContraffazione: 92,
      origineAlert: "EMVO",
      caseManager: "",
      caseManagerAssegnato: false,
      farmacia: "Ospedale San Giovanni - Milano",
      mah: "BioMed Italia S.r.l."
    ),
    a!map(
      idCase: "CASE-2024-00150",
      idAlert: "ALT-2024-001225",
      prodotto: "Terapia DEF 250mg",
      gtin: "08055544433322",
      seriale: "SN2024DEF123456",
      lotto: "LOT2024-077",
      dataScadenza: date(2025, 9, 15),
      dataGenerazione: today() - 5,
      stato: "CHIUSO_FALSO_POSITIVO",
      livelloRischio: "MEDIO",
      probabilitaContraffazione: 45,
      origineAlert: "NMVS",
      caseManager: "Laura Bianchi",
      caseManagerAssegnato: true,
      farmacia: "Farmacia Ospedaliera - Napoli",
      mah: "Generic Pharma S.p.A."
    ),
    a!map(
      idCase: "CASE-2024-00148",
      idAlert: "ALT-2024-001220",
      prodotto: "Vaccino GHI",
      gtin: "08011122233344",
      seriale: "SN2024GHI987654",
      lotto: "LOT2024-066",
      dataScadenza: date(2025, 3, 31),
      dataGenerazione: today() - 7,
      stato: "CHIUSO_CONTRAFFAZIONE",
      livelloRischio: "MOLTO_ALTO",
      probabilitaContraffazione: 98,
      origineAlert: "NMVS",
      caseManager: "Giuseppe Verdi",
      caseManagerAssegnato: true,
      farmacia: "ASL Torino Nord",
      mah: "Vaccine Corp S.p.A."
    )
  },

  /* ===== FILTRI E RICERCA ===== */
  local!searchText: "",
  local!filtroStato: null,
  local!filtroRischio: null,
  local!filtroAssegnazione: null,
  local!ordinamento: "dataGenerazione",
  local!ordinamentoAsc: false,

  /* ===== VISTA DETTAGLIO ===== */
  local!mostraDettaglio: false,
  local!caseSelezionato: null,

  /* ===== STORICO ATTIVITÀ (per dettaglio) ===== */
  local!storicoAttivita: {
    a!map(dataOra: now() - 1, azione: "Case creato automaticamente dal sistema NMVS", utente: "Sistema", tipo: "CREAZIONE"),
    a!map(dataOra: now() - 0.9, azione: "Alert L5 generato - Sospetta contraffazione", utente: "Sistema", tipo: "ALERT"),
    a!map(dataOra: now() - 0.8, azione: "Notifica inviata al MAH", utente: "Sistema", tipo: "NOTIFICA"),
    a!map(dataOra: now() - 0.5, azione: "Case assegnato a Mario Rossi", utente: "Admin", tipo: "ASSEGNAZIONE"),
    a!map(dataOra: now() - 0.3, azione: "Avviata analisi preliminare", utente: "Mario Rossi", tipo: "ANALISI"),
    a!map(dataOra: now() - 0.1, azione: "Richiesta documentazione supply chain", utente: "Mario Rossi", tipo: "RICHIESTA")
  },

  /* ===== DATI REPORT ===== */
  local!noteInvestigazione: "",
  local!conclusione: "",
  local!azioniCorrettive: "",

  /* ===== VISUALIZZAZIONE PDF ===== */
  local!mostraReportPDF: false,

  a!sectionLayout(
    label: "",
    contents: {
      /* ========== HEADER PRINCIPALE ========== */
      /* Barra superiore con logo e sistema */
      a!boxLayout(
        label: "",
        style: "ACCENT",
        contents: {
          a!columnsLayout(
            columns: {
              /* Logo e Branding */
              a!columnLayout(
                contents: {
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextIcon(icon: "shield", size: "LARGE"),
                              " ",
                              a!richTextIcon(icon: "medkit", size: "LARGE")
                            }
                          )
                        },
                        width: "EXTRA_NARROW"
                      ),
                      a!columnLayout(
                        contents: {
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "FMD COMPLIANCE",
                                size: "MEDIUM",
                                style: "STRONG"
                              )
                            }
                          ),
                          a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(
                                text: "Falsified Medicines Directive 2011/62/EU",
                                size: "SMALL"
                              )
                            }
                          )
                        }
                      )
                    },
                    alignVertical: "MIDDLE"
                  )
                },
                width: "NARROW_PLUS"
              ),
              /* Titolo Centrale */
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "ALERT MANAGEMENT SYSTEM",
                        size: "LARGE",
                        style: "STRONG"
                      )
                    },
                    align: "CENTER"
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: "Marketing Authorization Holder Portal",
                        size: "SMALL"
                      )
                    },
                    align: "CENTER"
                  )
                }
              ),
              /* Info Utente e Sistema */
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "user-circle", size: "MEDIUM"),
                      " ",
                      a!richTextItem(
                        text: loggedInUser(),
                        style: "STRONG"
                      )
                    },
                    align: "RIGHT"
                  ),
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "clock-o"),
                      " ",
                      a!richTextItem(
                        text: text(now(), "dd/mm/yyyy HH:mm")
                      )
                    },
                    align: "RIGHT"
                  )
                },
                width: "NARROW_PLUS"
              )
            },
            alignVertical: "MIDDLE"
          )
        },
        marginBelow: "NONE"
      ),

      /* Barra Alert L5 - Critico */
      a!boxLayout(
        label: "",
        style: "ERROR",
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!sideBySideLayout(
                    items: {
                      a!sideBySideItem(
                        item: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextIcon(icon: "exclamation-triangle", size: "MEDIUM"),
                            " ",
                            a!richTextItem(
                              text: "LIVELLO 5 - SOSPETTA CONTRAFFAZIONE",
                              size: "MEDIUM",
                              style: "STRONG"
                            )
                          }
                        )
                      ),
                      a!sideBySideItem(
                        item: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextItem(
                              text: " | ",
                              color: "SECONDARY"
                            ),
                            a!richTextItem(
                              text: "Gestione Case Alert Critici",
                              style: "EMPHASIS"
                            )
                          }
                        ),
                        width: "MINIMIZE"
                      )
                    },
                    alignVertical: "MIDDLE"
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "circle", color: "POSITIVE"),
                      " ",
                      a!richTextItem(
                        text: "Sistema Operativo",
                        size: "SMALL"
                      ),
                      "  |  ",
                      a!richTextIcon(icon: "database"),
                      " ",
                      a!richTextItem(
                        text: "NMVS Connected",
                        size: "SMALL"
                      )
                    },
                    align: "RIGHT"
                  )
                },
                width: "NARROW_PLUS"
              )
            },
            alignVertical: "MIDDLE"
          )
        },
        marginBelow: "STANDARD"
      ),

      /* ========== VISTA LISTA O DETTAGLIO ========== */
      if(
        local!mostraDettaglio,

        /* ==================== VISTA 2: DETTAGLIO CASE ALERT ==================== */
        {
          /* Breadcrumb / Torna alla lista */
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextItem(
                text: " Torna alla Lista Case",
                link: a!dynamicLink(
                  saveInto: {
                    a!save(local!mostraDettaglio, false),
                    a!save(local!caseSelezionato, null)
                  }
                )
              )
            },
            marginBelow: "STANDARD"
          ),

          /* Intestazione Case */
          a!cardLayout(
            contents: {
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextIcon(
                            icon: "folder-open",
                            size: "MEDIUM",
                            color: "NEGATIVE"
                          ),
                          " ",
                          a!richTextItem(
                            text: "CASE: " & local!caseSelezionato.idCase,
                            size: "LARGE",
                            style: "STRONG"
                          )
                        }
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: "Stato: ",
                            color: "SECONDARY"
                          ),
                          a!richTextItem(
                            text: substitute(local!caseSelezionato.stato, "_", " "),
                            style: "STRONG",
                            color: if(
                              local!caseSelezionato.stato = "APERTO",
                              "NEGATIVE",
                              if(
                                local!caseSelezionato.stato = "IN_ANALISI",
                                "#E67E22",
                                "POSITIVE"
                              )
                            )
                          )
                        },
                        align: "RIGHT"
                      )
                    },
                    width: "NARROW"
                  )
                }
              )
            },
            style: "ERROR",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Sezione 1: Identificativo e Origine */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "info-circle", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "IDENTIFICATIVO E ORIGINE ALERT", style: "STRONG")
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!textField(label: "ID Case", value: local!caseSelezionato.idCase, readOnly: true),
                      a!textField(label: "ID Alert", value: local!caseSelezionato.idAlert, readOnly: true)
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!textField(label: "Origine Alert", value: local!caseSelezionato.origineAlert, readOnly: true),
                      a!textField(label: "Data Generazione", value: text(local!caseSelezionato.dataGenerazione, "dd/mm/yyyy HH:mm"), readOnly: true)
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!textField(label: "Farmacia/Ospedale", value: local!caseSelezionato.farmacia, readOnly: true),
                      a!textField(label: "MAH", value: local!caseSelezionato.mah, readOnly: true)
                    }
                  )
                }
              )
            },
            style: "STANDARD",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Sezione 2: Dati Prodotto */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "cube", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "DATI PRODOTTO", style: "STRONG")
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!textField(label: "Nome Prodotto", value: local!caseSelezionato.prodotto, readOnly: true),
                      a!textField(label: "Codice GTIN", value: local!caseSelezionato.gtin, readOnly: true)
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!textField(label: "Numero Seriale", value: local!caseSelezionato.seriale, readOnly: true),
                      a!textField(label: "Lotto", value: local!caseSelezionato.lotto, readOnly: true)
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!textField(label: "Data Scadenza", value: text(local!caseSelezionato.dataScadenza, "dd/mm/yyyy"), readOnly: true)
                    }
                  )
                }
              )
            },
            style: "STANDARD",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Sezione 3: Livello Rischio e Probabilità Contraffazione */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "warning", color: "NEGATIVE"),
                  " ",
                  a!richTextItem(text: "VALUTAZIONE RISCHIO", style: "STRONG")
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!textField(
                        label: "Livello di Rischio",
                        value: substitute(local!caseSelezionato.livelloRischio, "_", " "),
                        readOnly: true
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!richTextDisplayField(
                        label: "Probabilità Contraffazione",
                        value: {
                          a!richTextItem(
                            text: local!caseSelezionato.probabilitaContraffazione & "%",
                            size: "LARGE",
                            style: "STRONG",
                            color: if(
                              local!caseSelezionato.probabilitaContraffazione >= 80,
                              "NEGATIVE",
                              if(
                                local!caseSelezionato.probabilitaContraffazione >= 50,
                                "#E67E22",
                                "POSITIVE"
                              )
                            )
                          )
                        }
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!gaugeField(
                        label: "",
                        labelPosition: "COLLAPSED",
                        percentage: local!caseSelezionato.probabilitaContraffazione / 100,
                        primaryText: a!gaugePercentage(),
                        secondaryText: "Rischio",
                        color: if(
                          local!caseSelezionato.probabilitaContraffazione >= 80,
                          "NEGATIVE",
                          if(
                            local!caseSelezionato.probabilitaContraffazione >= 50,
                            "WARN",
                            "POSITIVE"
                          )
                        )
                      )
                    }
                  )
                }
              )
            },
            style: "ERROR",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Sezione 4: Assegnazione Case Manager */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "user", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "ASSEGNAZIONE CASE MANAGER", style: "STRONG")
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!checkboxField(
                        label: "Case Assegnato",
                        labelPosition: "ABOVE",
                        choiceLabels: {"Case Manager assegnato"},
                        choiceValues: {true},
                        value: if(local!caseSelezionato.caseManagerAssegnato, {true}, {}),
                        disabled: true
                      )
                    },
                    width: "NARROW"
                  ),
                  a!columnLayout(
                    contents: {
                      a!textField(
                        label: "Case Manager",
                        value: if(
                          local!caseSelezionato.caseManagerAssegnato,
                          local!caseSelezionato.caseManager,
                          "Non assegnato"
                        ),
                        readOnly: true
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!buttonArrayLayout(
                        buttons: {
                          a!buttonWidget(
                            label: if(local!caseSelezionato.caseManagerAssegnato, "Riassegna", "Assegna"),
                            icon: "user-plus",
                            style: "SOLID"
                          )
                        },
                        align: "END"
                      )
                    },
                    width: "NARROW"
                  )
                },
                alignVertical: "MIDDLE"
              )
            },
            style: "STANDARD",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Sezione 5: Storico Attività */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "history", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "STORICO ATTIVITÀ E DECISIONI", style: "STRONG")
                }
              ),
              a!forEach(
                items: local!storicoAttivita,
                expression: a!boxLayout(
                  label: "",
                  style: "STANDARD",
                  contents: {
                    a!columnsLayout(
                      columns: {
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextIcon(
                                  icon: if(
                                    fv!item.tipo = "CREAZIONE", "plus-circle",
                                    if(fv!item.tipo = "ALERT", "exclamation-triangle",
                                    if(fv!item.tipo = "NOTIFICA", "envelope",
                                    if(fv!item.tipo = "ASSEGNAZIONE", "user",
                                    if(fv!item.tipo = "ANALISI", "search", "file-text"))))
                                  ),
                                  color: if(
                                    fv!item.tipo = "ALERT", "NEGATIVE",
                                    "ACCENT"
                                  )
                                )
                              }
                            )
                          },
                          width: "EXTRA_NARROW"
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: text(fv!item.dataOra, "dd/mm/yyyy HH:mm") & " - ",
                                  color: "SECONDARY"
                                ),
                                a!richTextItem(
                                  text: fv!item.azione,
                                  style: "STRONG"
                                )
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: "Utente: " & fv!item.utente,
                                  size: "SMALL",
                                  color: "SECONDARY"
                                )
                              }
                            )
                          }
                        )
                      }
                    )
                  },
                  marginBelow: "STANDARD"
                )
              )
            },
            style: "STANDARD",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Sezione 6: Report e Chiusura Case */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "file-text", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "REPORT E CHIUSURA CASE", style: "STRONG")
                }
              ),
              a!paragraphField(
                label: "Note Investigazione",
                labelPosition: "ABOVE",
                placeholder: "Inserire note relative all'investigazione...",
                value: local!noteInvestigazione,
                saveInto: local!noteInvestigazione,
                height: "MEDIUM"
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!dropdownField(
                        label: "Conclusione",
                        labelPosition: "ABOVE",
                        placeholder: "Seleziona conclusione...",
                        choiceLabels: {
                          "Falso Positivo - Errore di sistema",
                          "Falso Positivo - Errore operatore",
                          "Contraffazione Confermata",
                          "In attesa ulteriori verifiche"
                        },
                        choiceValues: {
                          "FALSO_POSITIVO_SISTEMA",
                          "FALSO_POSITIVO_OPERATORE",
                          "CONTRAFFAZIONE_CONFERMATA",
                          "IN_ATTESA"
                        },
                        value: local!conclusione,
                        saveInto: local!conclusione
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!paragraphField(
                        label: "Azioni Correttive",
                        labelPosition: "ABOVE",
                        placeholder: "Descrivere le azioni correttive intraprese...",
                        value: local!azioniCorrettive,
                        saveInto: local!azioniCorrettive,
                        height: "SHORT"
                      )
                    }
                  )
                }
              ),
              a!buttonArrayLayout(
                buttons: {
                  a!buttonWidget(
                    label: "Salva Bozza",
                    icon: "save",
                    style: "OUTLINE"
                  ),
                  a!buttonWidget(
                    label: "Genera Report PDF",
                    icon: "file-pdf-o",
                    style: "OUTLINE",
                    saveInto: a!save(local!mostraReportPDF, true)
                  ),
                  a!buttonWidget(
                    label: "Chiudi Case",
                    icon: "check",
                    style: "SOLID",
                    confirmHeader: "Conferma Chiusura Case",
                    confirmMessage: "Sei sicuro di voler chiudere questo case? L'operazione sarà registrata nel sistema.",
                    confirmButtonLabel: "Conferma Chiusura",
                    cancelButtonLabel: "Annulla"
                  )
                },
                align: "END",
                marginAbove: "STANDARD"
              )
            },
            style: "STANDARD",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* ========== ANTEPRIMA REPORT PDF ========== */
          if(
            local!mostraReportPDF,
            a!cardLayout(
              contents: {
                /* ===== BANNER HEADER REPORT ===== */
                a!boxLayout(
                  label: "",
                  style: "ACCENT",
                  contents: {
                    a!columnsLayout(
                      columns: {
                        /* Logo e Nome Sistema */
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextIcon(icon: "shield", size: "LARGE"),
                                " ",
                                a!richTextIcon(icon: "medkit", size: "LARGE")
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: "FMD ALERT SYSTEM",
                                  size: "MEDIUM",
                                  style: "STRONG"
                                )
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: "Falsified Medicines Directive",
                                  size: "SMALL"
                                )
                              }
                            )
                          },
                          width: "NARROW"
                        ),
                        /* Titolo Centrale */
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: "ROOT CAUSE ANALYSIS",
                                  size: "LARGE",
                                  style: "STRONG"
                                )
                              },
                              align: "CENTER"
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: "REPORT INVESTIGAZIONE ALERT L5",
                                  size: "MEDIUM",
                                  style: "STRONG"
                                )
                              },
                              align: "CENTER"
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(
                                  text: "Sospetta Contraffazione Farmaco",
                                  size: "SMALL"
                                )
                              },
                              align: "CENTER"
                            )
                          }
                        ),
                        /* Info Documento */
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Doc. N°: ", style: "STRONG"),
                                a!richTextItem(text: "RCA-" & local!caseSelezionato.idCase)
                              },
                              align: "RIGHT"
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Rev.: ", style: "STRONG"),
                                a!richTextItem(text: "1.0")
                              },
                              align: "RIGHT"
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Data: ", style: "STRONG"),
                                a!richTextItem(text: text(today(), "dd/mm/yyyy"))
                              },
                              align: "RIGHT"
                            )
                          },
                          width: "NARROW"
                        )
                      },
                      alignVertical: "MIDDLE"
                    )
                  },
                  marginBelow: "NONE"
                ),

                /* Barra Classificazione */
                a!boxLayout(
                  label: "",
                  style: "ERROR",
                  contents: {
                    a!columnsLayout(
                      columns: {
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextIcon(icon: "exclamation-triangle"),
                                " ",
                                a!richTextItem(
                                  text: "DOCUMENTO RISERVATO - ALERT LIVELLO 5 CRITICO",
                                  style: "STRONG"
                                )
                              },
                              align: "CENTER"
                            )
                          }
                        )
                      }
                    )
                  },
                  marginBelow: "STANDARD"
                ),

                /* Sezione 1: Intestazione */
                a!boxLayout(
                  label: "1. INTESTAZIONE CASE",
                  style: "STANDARD",
                  contents: {
                    a!columnsLayout(
                      columns: {
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "ID CASE: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.idCase)
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "ID ALERT: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.idAlert)
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Origine Alert: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.origineAlert)
                              }
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Data Apertura: ", style: "STRONG"),
                                a!richTextItem(text: text(local!caseSelezionato.dataGenerazione, "dd/mm/yyyy"))
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Data Chiusura: ", style: "STRONG"),
                                a!richTextItem(text: text(today(), "dd/mm/yyyy"))
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Alert Manager: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.caseManager)
                              }
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Stato Risoluzione: ", style: "STRONG"),
                                a!richTextItem(
                                  text: if(len(local!conclusione) > 0, substitute(local!conclusione, "_", " "), "In corso"),
                                  color: if(len(local!conclusione) > 0, "POSITIVE", "#E67E22")
                                )
                              }
                            )
                          }
                        )
                      }
                    )
                  },
                  marginAbove: "STANDARD"
                ),

                /* Sezione 2: Dati Prodotto */
                a!boxLayout(
                  label: "2. DATI PRODOTTO",
                  style: "STANDARD",
                  contents: {
                    a!columnsLayout(
                      columns: {
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Nome Prodotto: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.prodotto)
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Codice GTIN: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.gtin)
                              }
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Numero Seriale: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.seriale)
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Lotto: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.lotto)
                              }
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Data Scadenza: ", style: "STRONG"),
                                a!richTextItem(text: text(local!caseSelezionato.dataScadenza, "dd/mm/yyyy"))
                              }
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "MAH: ", style: "STRONG"),
                                a!richTextItem(text: local!caseSelezionato.mah)
                              }
                            )
                          }
                        )
                      }
                    )
                  },
                  marginAbove: "STANDARD"
                ),

                /* Sezione 3: Valutazione Rischio */
                a!boxLayout(
                  label: "3. VALUTAZIONE RISCHIO",
                  style: "ERROR",
                  contents: {
                    a!columnsLayout(
                      columns: {
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Livello Rischio Iniziale: ", style: "STRONG"),
                                a!richTextItem(
                                  text: substitute(local!caseSelezionato.livelloRischio, "_", " "),
                                  color: "NEGATIVE",
                                  style: "STRONG"
                                )
                              }
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Probabilità Contraffazione: ", style: "STRONG"),
                                a!richTextItem(
                                  text: local!caseSelezionato.probabilitaContraffazione & "%",
                                  color: "NEGATIVE",
                                  style: "STRONG"
                                )
                              }
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Livello Finale: ", style: "STRONG"),
                                a!richTextItem(
                                  text: if(
                                    or(local!conclusione = "FALSO_POSITIVO_SISTEMA", local!conclusione = "FALSO_POSITIVO_OPERATORE"),
                                    "BASSO (Falso Positivo)",
                                    if(local!conclusione = "CONTRAFFAZIONE_CONFERMATA", "CRITICO", "In valutazione")
                                  ),
                                  color: if(
                                    or(local!conclusione = "FALSO_POSITIVO_SISTEMA", local!conclusione = "FALSO_POSITIVO_OPERATORE"),
                                    "POSITIVE",
                                    "NEGATIVE"
                                  )
                                )
                              }
                            )
                          }
                        )
                      }
                    )
                  },
                  marginAbove: "STANDARD"
                ),

                /* Sezione 4: Analisi Sviluppata */
                a!boxLayout(
                  label: "4. ANALISI SVILUPPATA",
                  style: "STANDARD",
                  contents: {
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(text: "Descrizione Alert: ", style: "STRONG"),
                        a!richTextItem(text: "UI non presente nel database NMVS - Sospetta contraffazione farmaco")
                      }
                    ),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(text: "Analisi Effettuata: ", style: "STRONG"),
                        a!richTextItem(text: if(len(local!noteInvestigazione) > 0, local!noteInvestigazione, "Verifica della supply chain, controllo documentazione, analisi batch records, confronto con database produzione."))
                      },
                      marginAbove: "STANDARD"
                    ),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(text: "Fonti Consultate: ", style: "STRONG"),
                        a!richTextItem(text: "NMVS, Database produzione MAH, Documentazione lotto, Certificati di analisi")
                      },
                      marginAbove: "STANDARD"
                    ),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(text: "Anomalie Riscontrate: ", style: "STRONG"),
                        a!richTextItem(text: "Seriale non corrispondente ai records di produzione")
                      },
                      marginAbove: "STANDARD"
                    )
                  },
                  marginAbove: "STANDARD"
                ),

                /* Sezione 5: Storico Attività */
                a!boxLayout(
                  label: "5. STORICO ATTIVITÀ E DECISIONI",
                  style: "STANDARD",
                  contents: {
                    a!gridLayout(
                      label: "",
                      labelPosition: "COLLAPSED",
                      headerCells: {
                        a!gridLayoutHeaderCell(label: "Data/Ora"),
                        a!gridLayoutHeaderCell(label: "Utente"),
                        a!gridLayoutHeaderCell(label: "Azione"),
                        a!gridLayoutHeaderCell(label: "Note")
                      },
                      rows: a!forEach(
                        items: local!storicoAttivita,
                        expression: a!gridRowLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: text(fv!item.dataOra, "dd/mm/yyyy HH:mm")
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: fv!item.utente
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: fv!item.azione
                            ),
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: "-"
                            )
                          }
                        )
                      )
                    )
                  },
                  marginAbove: "STANDARD"
                ),

                /* Sezione 6: Decisione Finale */
                a!boxLayout(
                  label: "6. DECISIONE FINALE E CHIUSURA",
                  style: "STANDARD",
                  contents: {
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(text: "Conclusione: ", style: "STRONG"),
                        a!richTextItem(
                          text: if(len(local!conclusione) > 0, substitute(local!conclusione, "_", " "), "In attesa di decisione"),
                          style: "STRONG"
                        )
                      }
                    ),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextItem(text: "Azioni Correttive: ", style: "STRONG"),
                        a!richTextItem(text: if(len(local!azioniCorrettive) > 0, local!azioniCorrettive, "Nessuna azione correttiva specificata"))
                      },
                      marginAbove: "STANDARD"
                    ),
                    a!columnsLayout(
                      columns: {
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Firma Alert Manager: ", style: "STRONG"),
                                a!richTextItem(text: "________________________")
                              },
                              marginAbove: "STANDARD"
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Data: ", style: "STRONG"),
                                a!richTextItem(text: text(today(), "dd/mm/yyyy"))
                              },
                              marginAbove: "STANDARD"
                            )
                          }
                        ),
                        a!columnLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: {
                                a!richTextItem(text: "Timbro: ", style: "STRONG"),
                                a!richTextItem(text: "[_____]")
                              },
                              marginAbove: "STANDARD"
                            )
                          }
                        )
                      }
                    )
                  },
                  marginAbove: "STANDARD"
                ),

                /* Footer Report */
                a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: "________________________________________________________________________________________________________",
                  align: "CENTER",
                  marginAbove: "STANDARD"
                ),
                a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextItem(
                      text: "Documento generato automaticamente dal Sistema di Gestione Alert FMD - " & text(now(), "dd/mm/yyyy HH:mm:ss"),
                      size: "SMALL",
                      color: "SECONDARY"
                    )
                  },
                  align: "CENTER"
                ),

                /* Pulsanti azioni */
                a!buttonArrayLayout(
                  buttons: {
                    a!buttonWidget(
                      label: "Scarica PDF",
                      icon: "download",
                      style: "SOLID"
                    ),
                    a!buttonWidget(
                      label: "Stampa",
                      icon: "print",
                      style: "OUTLINE"
                    ),
                    a!buttonWidget(
                      label: "Invia via Email",
                      icon: "envelope",
                      style: "OUTLINE"
                    ),
                    a!buttonWidget(
                      label: "Chiudi Anteprima",
                      icon: "times",
                      style: "OUTLINE",
                      saveInto: a!save(local!mostraReportPDF, false)
                    )
                  },
                  align: "CENTER",
                  marginAbove: "STANDARD"
                )
              },
              style: "STANDARD",
              padding: "STANDARD",
              marginBelow: "STANDARD"
            ),
            {}
          )
        },

        /* ==================== VISTA 1: LISTA CASE ALERT ==================== */
        {
          /* KPI Dashboard */
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!cardLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "Case Aperti", size: "SMALL", color: "SECONDARY")
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "1", size: "LARGE", style: "STRONG", color: "NEGATIVE")
                      )
                    },
                    style: "STANDARD",
                    padding: "STANDARD"
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!cardLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "In Analisi", size: "SMALL", color: "SECONDARY")
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "1", size: "LARGE", style: "STRONG", color: "#E67E22")
                      )
                    },
                    style: "STANDARD",
                    padding: "STANDARD"
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!cardLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "Non Assegnati", size: "SMALL", color: "SECONDARY")
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "1", size: "LARGE", style: "STRONG", color: "NEGATIVE")
                      )
                    },
                    style: "STANDARD",
                    padding: "STANDARD"
                  )
                }
              ),
              a!columnLayout(
                contents: {
                  a!cardLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "Chiusi (7gg)", size: "SMALL", color: "SECONDARY")
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(text: "2", size: "LARGE", style: "STRONG", color: "POSITIVE")
                      )
                    },
                    style: "STANDARD",
                    padding: "STANDARD"
                  )
                }
              )
            },
            marginBelow: "STANDARD"
          ),

          /* Filtri e Ricerca */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "filter", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "RICERCA E FILTRI", style: "STRONG")
                }
              ),
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!textField(
                        label: "Ricerca",
                        labelPosition: "ABOVE",
                        placeholder: "Cerca per ID Case, ID Alert, Prodotto...",
                        value: local!searchText,
                        saveInto: local!searchText
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!dropdownField(
                        label: "Stato",
                        labelPosition: "ABOVE",
                        placeholder: "Tutti",
                        choiceLabels: {"Aperto", "In Analisi", "Chiuso - Falso Positivo", "Chiuso - Contraffazione"},
                        choiceValues: {"APERTO", "IN_ANALISI", "CHIUSO_FALSO_POSITIVO", "CHIUSO_CONTRAFFAZIONE"},
                        value: local!filtroStato,
                        saveInto: local!filtroStato
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!dropdownField(
                        label: "Livello Rischio",
                        labelPosition: "ABOVE",
                        placeholder: "Tutti",
                        choiceLabels: {"Medio", "Alto", "Molto Alto"},
                        choiceValues: {"MEDIO", "ALTO", "MOLTO_ALTO"},
                        value: local!filtroRischio,
                        saveInto: local!filtroRischio
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!dropdownField(
                        label: "Assegnazione",
                        labelPosition: "ABOVE",
                        placeholder: "Tutti",
                        choiceLabels: {"Assegnati", "Non Assegnati"},
                        choiceValues: {true, false},
                        value: local!filtroAssegnazione,
                        saveInto: local!filtroAssegnazione
                      )
                    }
                  ),
                  a!columnLayout(
                    contents: {
                      a!buttonArrayLayout(
                        buttons: {
                          a!buttonWidget(label: "Cerca", icon: "search", style: "SOLID"),
                          a!buttonWidget(
                            label: "Reset",
                            icon: "times",
                            style: "OUTLINE",
                            saveInto: {
                              a!save(local!searchText, ""),
                              a!save(local!filtroStato, null),
                              a!save(local!filtroRischio, null),
                              a!save(local!filtroAssegnazione, null)
                            }
                          )
                        },
                        align: "END"
                      )
                    },
                    width: "NARROW"
                  )
                },
                alignVertical: "BOTTOM"
              )
            },
            style: "STANDARD",
            padding: "STANDARD",
            marginBelow: "STANDARD"
          ),

          /* Tabella Case Alert */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "list", color: "ACCENT"),
                  " ",
                  a!richTextItem(text: "LISTA CASE ALERT L5", style: "STRONG"),
                  " ",
                  a!richTextItem(text: "(" & count(local!caseAlerts) & " case)", color: "SECONDARY")
                }
              ),
              a!gridLayout(
                label: "",
                labelPosition: "COLLAPSED",
                headerCells: {
                  a!gridLayoutHeaderCell(label: "ID Case"),
                  a!gridLayoutHeaderCell(label: "ID Alert"),
                  a!gridLayoutHeaderCell(label: "Prodotto"),
                  a!gridLayoutHeaderCell(label: "Data"),
                  a!gridLayoutHeaderCell(label: "Stato"),
                  a!gridLayoutHeaderCell(label: "Rischio"),
                  a!gridLayoutHeaderCell(label: "Manager"),
                  a!gridLayoutHeaderCell(label: "Azioni")
                },
                rows: a!forEach(
                  items: local!caseAlerts,
                  expression: a!gridRowLayout(
                    contents: {
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: fv!item.idCase,
                            style: "STRONG",
                            link: a!dynamicLink(
                              saveInto: {
                                a!save(local!caseSelezionato, fv!item),
                                a!save(local!mostraDettaglio, true)
                              }
                            )
                          )
                        }
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: fv!item.idAlert
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: fv!item.prodotto
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: text(fv!item.dataGenerazione, "dd/mm/yyyy")
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: substitute(fv!item.stato, "_", " "),
                            style: "STRONG",
                            color: if(
                              fv!item.stato = "APERTO", "NEGATIVE",
                              if(fv!item.stato = "IN_ANALISI", "#E67E22", "POSITIVE")
                            )
                          )
                        }
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: substitute(fv!item.livelloRischio, "_", " "),
                            style: "STRONG",
                            color: if(
                              fv!item.livelloRischio = "MOLTO_ALTO", "NEGATIVE",
                              if(fv!item.livelloRischio = "ALTO", "#E67E22", "ACCENT")
                            )
                          )
                        }
                      ),
                      a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          if(
                            fv!item.caseManagerAssegnato,
                            {
                              a!richTextIcon(icon: "flag", color: "POSITIVE"),
                              " ",
                              a!richTextItem(text: fv!item.caseManager)
                            },
                            {
                              a!richTextIcon(icon: "flag-o", color: "NEGATIVE"),
                              " ",
                              a!richTextItem(text: "Non assegnato", color: "SECONDARY")
                            }
                          )
                        }
                      ),
                      a!buttonArrayLayout(
                        buttons: {
                          a!buttonWidget(
                            label: "",
                            icon: "eye",
                            style: "OUTLINE",
                            size: "SMALL",
                            saveInto: {
                              a!save(local!caseSelezionato, fv!item),
                              a!save(local!mostraDettaglio, true)
                            }
                          ),
                          a!buttonWidget(
                            label: "",
                            icon: "user-plus",
                            style: "OUTLINE",
                            size: "SMALL",
                            disabled: fv!item.caseManagerAssegnato
                          )
                        }
                      )
                    }
                  )
                ),
                selectionStyle: "ROW_HIGHLIGHT"
              )
            },
            style: "STANDARD",
            padding: "STANDARD"
          )
        }
      )
    }
  )
)
