# Formation Symfony

## I. Installation et configuration

```bash
$ make deploy
```

Vérifiez la configuration du fichier `.env.local`

```bash
$ make start
$ make open

# Pour couper votre serveur :
$ make stop

# Pour davantage de commandes :
$ make
```

Voilà!

En mode développement, n’oubliez pas de régénérer vos `assets` si vous changez les sources :

```bash
$ make assets-watch
```

## II. Synchronisation du projet

Au choix :
- Via `GitHub Desktop` : Repository > Pull
- Via votre console :
    ```bash
    $ git pull --rebase
    ```
