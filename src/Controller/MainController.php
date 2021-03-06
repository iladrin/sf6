<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends AbstractController
{

    #[Route('/', name:'homepage', methods: 'GET')]
    public function home(): Response
    {
        return $this->render('main/home.html.twig');
    }
}
