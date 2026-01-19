import 'package:flutter/material.dart';
import 'service/movie_service.dart';

class MovieListPage extends StatefulWidget {
  final MovieService movieService;

  const MovieListPage({super.key, required this.movieService});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<Movie> movies = [];
  final Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final loadedMovies = await widget.movieService.loadLocalMovies();
    setState(() => movies = loadedMovies);
  }

  void toggleFavorite(String title) {
    setState(() {
      if (favorites.contains(title)) {
        favorites.remove(title);
      } else {
        favorites.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Liste de films'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesPage(
                  favorites: favorites,
                  movies: movies,
                  toggleFavorite: toggleFavorite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : InterfaceView(
              movies: movies,
              favorites: favorites,
              toggleFavorite: toggleFavorite,
            ),
    );
  }
}

class InterfaceView extends StatefulWidget {
  final List<Movie> movies;
  final Set<String> favorites;
  final Function(String) toggleFavorite;

  const InterfaceView({
    super.key,
    required this.movies,
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  State<InterfaceView> createState() => _InterfaceViewState();
}

class _InterfaceViewState extends State<InterfaceView> {
  bool gridView = false;
  String searchQuery = '';
  String sortValue = 'A-Z';

  @override
  Widget build(BuildContext context) {
    // Filtrage par titre
    List<Movie> filteredMovies = widget.movies
        .where((movie) => movie.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    // Tri
    if (sortValue == 'A-Z') {
      filteredMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortValue == 'Z-A') {
      filteredMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (sortValue == 'Année croissante') {
      filteredMovies.sort((a, b) => a.year.compareTo(b.year));
    } else if (sortValue == 'Année décroissante') {
      filteredMovies.sort((a, b) => b.year.compareTo(a.year));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Rechercher par titre...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: sortValue,
                items: const [
                  DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
                  DropdownMenuItem(value: 'Z-A', child: Text('Z-A')),
                  DropdownMenuItem(value: 'Année croissante', child: Text('Année ↑')),
                  DropdownMenuItem(value: 'Année décroissante', child: Text('Année ↓')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      sortValue = value;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.grid_view, color: gridView ? Colors.blue : null),
                onPressed: () {
                  setState(() {
                    gridView = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.view_agenda,
                  color: !gridView ? Colors.blue : null,
                ),
                onPressed: () {
                  setState(() {
                    gridView = false;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredMovies.isEmpty
              ? const Center(child: Text('Aucun film trouvé'))
              : gridView
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) => MovieCard(
                        movie: filteredMovies[index],
                        isFavorite: widget.favorites.contains(filteredMovies[index].title),
                        onFavoriteTap: () => widget.toggleFavorite(filteredMovies[index].title),
                        gridView: true,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) => MovieCard(
                        movie: filteredMovies[index],
                        isFavorite: widget.favorites.contains(filteredMovies[index].title),
                        onFavoriteTap: () => widget.toggleFavorite(filteredMovies[index].title),
                        gridView: false,
                      ),
                    ),
        ),
      ],
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final Set<String> favorites;
  final List<Movie> movies;
  final Function(String) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.movies,
    required this.toggleFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool gridView = false;

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = widget.movies
        .where((movie) => widget.favorites.contains(movie.title))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Films favoris'),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view, color: gridView ? Colors.blue : null),
            onPressed: () {
              setState(() {
                gridView = true;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.view_agenda,
              color: !gridView ? Colors.blue : null,
            ),
            onPressed: () {
              setState(() {
                gridView = false;
              });
            },
          ),
        ],
      ),
      body: favoriteMovies.isEmpty
          ? const Center(child: Text('Aucun favori'))
          : gridView
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) => MovieCard(
                movie: favoriteMovies[index],
                isFavorite: true,
                onFavoriteTap: () {
                  setState(() {
                    widget.toggleFavorite(favoriteMovies[index].title);
                  });
                },
                favoriteIcon: Icons.delete,
                gridView: true,
              ),
            )
          : ListView(
              children: favoriteMovies
                  .map(
                    (movie) => MovieCard(
                      movie: movie,
                      isFavorite: true,
                      onFavoriteTap: () {
                        setState(() {
                          widget.toggleFavorite(movie.title);
                        });
                      },
                      favoriteIcon: Icons.delete,
                      gridView: false,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData? favoriteIcon;
  final bool gridView;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.favoriteIcon,
    required this.gridView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(
              movie: movie,
              isFavorite: isFavorite,
              onFavoriteTap: onFavoriteTap,
            ),
          ),
        ),
        child: gridView
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      movie.poster,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${movie.year}'),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              favoriteIcon ??
                                  (isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                              color: isFavorite && favoriteIcon == null
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: onFavoriteTap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    movie.poster,
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 75,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie),
                    ),
                  ),
                ),
                title: Text(movie.title),
                subtitle: Text('${movie.year}'),
                trailing: IconButton(
                  icon: Icon(
                    favoriteIcon ??
                        (isFavorite ? Icons.favorite : Icons.favorite_border),
                    color: isFavorite && favoriteIcon == null
                        ? Colors.red
                        : null,
                  ),
                  onPressed: onFavoriteTap,
                ),
              ),
      ),
    );
  }
}

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  final bool initialIsFavorite;
  final VoidCallback onFavoriteTap;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required bool isFavorite,
    required this.onFavoriteTap,
  }) : initialIsFavorite = isFavorite;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialIsFavorite;
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
    widget.onFavoriteTap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.movie.poster,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 400,
                color: Colors.grey[300],
                child: const Icon(Icons.movie, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.movie.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Synopsis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
